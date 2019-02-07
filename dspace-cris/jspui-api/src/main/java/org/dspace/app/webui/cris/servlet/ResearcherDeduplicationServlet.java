package org.dspace.app.webui.cris.servlet;

import org.dspace.app.cris.model.ResearcherPage;
import org.dspace.app.cris.model.dto.ResearcherPageDTO;
import org.dspace.app.cris.rpdeduplication.service.ResearcherMergeService;
import org.dspace.app.cris.rpdeduplication.service.impl.ResearcherMergeServiceImpl;
import org.dspace.app.webui.discovery.DiscoverUtility;
import org.dspace.app.webui.search.SearchProcessorException;
import org.dspace.app.webui.servlet.DSpaceServlet;
import org.dspace.app.webui.util.JSPManager;
import org.dspace.authorize.AuthorizeException;
import org.dspace.authorize.AuthorizeManager;
import org.dspace.content.DSpaceObject;
import org.dspace.core.Context;
import org.dspace.discovery.DiscoverQuery;
import org.dspace.discovery.DiscoverResult;
import org.dspace.discovery.SearchServiceException;
import org.dspace.discovery.SearchUtils;
import org.dspace.discovery.configuration.DiscoveryConfiguration;
import org.dspace.utils.DSpace;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ResearcherDeduplicationServlet extends DSpaceServlet {

    @Override
    protected void doDSGet(Context context, HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException, AuthorizeException {

        String query = request.getParameter("query");

        if (query != null && !query.isEmpty()) {
            try {
                doSimpleSearch(context, request, response);
            } catch (SearchProcessorException e) {
                e.printStackTrace();
            }
        }

        JSPManager.showJSP(request, response,
                "/rp-deduplication/researcher-deduplication.jsp");
    }

    @Override
    protected void doDSPost(Context context, HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException, AuthorizeException {
        String original = request.getParameter("original");
        String duplikati = request.getParameter("duplikati");

        String[] duplikatiNiz = duplikati.split(",");

        DSpace dspace = new DSpace();
        ResearcherMergeService researcherMergeService = dspace.getServiceManager().getServiceByName("researcherMergeService", ResearcherMergeServiceImpl.class);

        Boolean success = researcherMergeService.merge(original, duplikatiNiz);

        request.setAttribute("success", success);

        JSPManager.showJSP(request, response,
                "/rp-deduplication/researcher-deduplication.jsp");
    }

    private void doSimpleSearch(Context context, HttpServletRequest request, HttpServletResponse response)
            throws SearchProcessorException, IOException, ServletException {
        String configurationName = "researcherprofiles";

        DSpaceObject scope = null;

        DiscoveryConfiguration discoveryConfiguration = SearchUtils.getDiscoveryConfigurationByName(configurationName);

        DiscoverQuery queryArgs = DiscoverUtility.getDiscoverQuery(context, request, scope, configurationName, true);

        queryArgs.setSpellCheck(discoveryConfiguration.isSpellCheckEnabled());

        // Perform the search
        DiscoverResult qResults = null;
        try {
            qResults = SearchUtils.getSearchService().search(context, scope, queryArgs);

//            // Pass in some page qualities
//            // total number of pages
//            long pageTotal = 1 + ((qResults.getTotalSearchResults() - 1) / qResults.getMaxResults());
//
//            // current page being displayed
//            long pageCurrent = 1 + (qResults.getStart() / qResults.getMaxResults());
//
//            // pageLast = min(pageCurrent+3,pageTotal)
//            long pageLast = ((pageCurrent + 3) > pageTotal) ? pageTotal : (pageCurrent + 3);
//
//            // pageFirst = max(1,pageCurrent-3)
//            long pageFirst = ((pageCurrent - 3) > 1) ? (pageCurrent - 3) : 1;
//
//            // Pass the results to the display JSP
//            request.setAttribute("pagetotal", new Long(pageTotal));
//            request.setAttribute("pagecurrent", new Long(pageCurrent));
//            request.setAttribute("pagelast", new Long(pageLast));
//            request.setAttribute("pagefirst", new Long(pageFirst));
//            request.setAttribute("spellcheck", qResults.getSpellCheckQuery());

            if (qResults.getDspaceObjects() != null && !qResults.getDspaceObjects().isEmpty()) {
                List<ResearcherPageDTO> resultList = new ArrayList<>();

                for (DSpaceObject dso : qResults.getDspaceObjects()) {
                    ResearcherPage rp = (ResearcherPage) dso;
                    ResearcherPageDTO rpDTO = new ResearcherPageDTO();

                    rpDTO.setSourceID(rp.getCrisID());
                    rpDTO.setFullName(rp.getName());

                    resultList.add(rpDTO);
                }

                request.setAttribute("resultList", resultList);
            }

//            request.setAttribute("queryresults", qResults);

            try {
                if (AuthorizeManager.isAdmin(context)) {
                    // Set a variable to create admin buttons
                    request.setAttribute("admin_button", new Boolean(true));
                }
            } catch (SQLException e) {
                throw new SearchProcessorException(e.getMessage(), e);
            }
        } catch (SearchServiceException e) {
            request.setAttribute("search.error", true);
            request.setAttribute("search.error.message", e.getMessage());
        }

        JSPManager.showJSP(request, response,
                "/rp-deduplication/researcher-deduplication.jsp");
    }
}
