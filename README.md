[![Stories in Ready](https://badge.waffle.io/TaihuaLi/NPDB_Data.png?label=ready&title=Ready)](https://waffle.io/TaihuaLi/NPDB_Data)
# Data Analysis on NPDB Dataset

### Dataset Description
The [NPDB Public Use Data File] (http://www.npdb.hrsa.gov/resources/publicData.jsp) contains information on specific variables taken from Adverse Action Reports and Medical Malpractice Payment Reports received by the NPDB on licensed health care practitioners, as well as information from reports of Medicare and Medicaid exclusion actions.

The NPDB Public Use Data File contains selected variables from medical malpractice payment and adverse licensure, clinical privileges, professional society membership, and Drug Enforcement Administration (DEA) reports (adverse actions) received by the NPDB concerning physicians, dentists, and other licensed health care practitioners. It also includes reports of Medicare and Medicaid exclusion actions taken by the Department of HHS Office of Inspector General.

### About The Project
This project involved multiple attempts to create a meaningful, predictive model using medical malpractice payment records from the National Practitioner Databank (NPDB) Public Use File downloaded from www.npdb.hrsa.gov (accessed 1/31/2016). Our team was composed of two MSPA students - Taihua Li and Trish Lugtu; and two MSIS students - Michael Marre and Zengyi Zhu. Together, we brought a nice balance of different skillsets to the team.


    “The NPDB Public Use Data File contains selected variables from medical malpractice payment and adverse licensure, clinical privileges, professional society membership, and Drug Enforcement Administration (DEA) reports (adverse actions) received by the NPDB concerning physicians, dentists, and other licensed health care practitioners. It also includes reports of Medicare and Medicaid exclusion actions taken by the Department of HHS Office of Inspector General.” – npdb.hrsa.gov
 
After doing a thorough exploration of the 54 attributes in the data file, we decided to focus our analysis on a subset of medical malpractice payment reports collected after 2004 for physicians with diagnosis-related cases. We then further segmented this data to perform a comparison between two regions of the U.S. - the Northeast (Region 5) and Southeast (Region 6). We chose these regions because they included several states with the highest volumes of malpractice claims in the country, which ensured ample data for each subteam.

Finally, our team split into two subteams to tackle analyses in parallel with each other. Each subteam included a MSPA-MSIS pairing - Taihua and Zengyi formed the Region 5 Subteam, and Trish and Mike formed the Region 6 Subteam. After two attempts with different dependent variables and a series of analyses, each subteam reached similar models with significant and meaningful results.

### Team Members
- [Taihua Li] (https://www.linkedin.com/in/taihuali)
- [Trish Lugtu] (https://www.linkedin.com/in/trishlugtu)
- [Mike Marre] (https://www.linkedin.com/in/michaelmarre)
- [Zengyi Zhu] (https://www.linkedin.com/in/zengyizhu)

Note: this project code is in [R](https://www.r-project.org)

![alt text](http://www.cdm.depaul.edu/ipd/PublishingImages/hero-data-science-for-business-@2x.jpg)
