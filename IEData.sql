SELECT
  LocalizedDataStringsSites.String,
  dbo.vAccessibleSubjects.SubjectNameForRole,
  dbo.fnFormatDataPageName(dbo.DataPages.DataPageName,dbo.DataPages.PageRepeatNumber,( dbo.LocalizedDataStrings.String ),( ISNULL(LocalizedDataStringsFolders.String,'Root Folder') ),dbo.Instances.InstanceRepeatNumber,dbo.vAccessibleSubjects.SubjectDate,dbo.DataPages.DataPageDate),
  dbo.fnFormatRecordName(dbo.Records.RecordName,dbo.Records.RecordPosition,( dbo.LocalizedDataStrings.String ),( ISNULL(LocalizedDataStringsFolders.String,'Root Folder') ),dbo.Instances.InstanceRepeatNumber, dbo.vAccessibleSubjects.SubjectDate,dbo.DataPages.DataPageDate,dbo.Records.RecordDate),
  dbo.Records.RecordPosition,
  LocalizedDataStringsFields.String,
  RTRIM((CASE WHEN (dbo.vBODataPoints.DataDictEntryID IS NOT NULL and  
dbo.DataDictionaryEntries.DataDictionaryEntryID=  
dbo.vBODataPoints.DataDictEntryID) then  
dbo.fnLocalDefault(dbo.DataDictionaryEntries.UserDataStringID)   
WHEN dbo.vBODataPoints.DataDictEntryID is null then RTRIM((CASE WHEN (dbo.vBODataPoints.MissingCode IS NOT NULL and  
dbo.MissingCodes.MissingCodeID=dbo.vBODataPoints.MissingCode) then  
(dbo.MissingCodes.MissingCode + ' - ''' + ISNULL(LocalizedDataStringsMC.String,'')+'''')   
ELSE dbo.vBODataPoints.Data  
END) )
END) ),
  dbo.Records.RecordID,
  dbo.Fields.SASLabel,
  LocalizedDataStringsSubjectStatus.String,
  LocalizedDataStringsProjects.String,
  LocalizedDataStringsSiteGroups.String
FROM
  dbo.DataDictionaryEntries RIGHT OUTER JOIN dbo.vBODataPoints ON (dbo.vBODataPoints.DataDictEntryID=dbo.DataDictionaryEntries.DataDictionaryEntryID)
   INNER JOIN dbo.Records ON (dbo.vBODataPoints.RecordID=dbo.Records.RecordID)
   LEFT OUTER JOIN dbo.Instances ON (dbo.Records.InstanceID=dbo.Instances.InstanceID)
   LEFT OUTER JOIN dbo.cv_Folders ON (dbo.cv_Folders.FolderID=dbo.Instances.FolderID)
   LEFT OUTER JOIN dbo.LocalizedDataStrings  LocalizedDataStringsFolders ON (dbo.cv_Folders.FolderName=LocalizedDataStringsFolders.StringID)
   INNER JOIN dbo.DataPages ON (dbo.Records.DataPageID=dbo.DataPages.DataPageID)
   INNER JOIN dbo.vAccessibleSubjects ON (dbo.vAccessibleSubjects.SubjectID=dbo.DataPages.SubjectID)
   INNER JOIN dbo.StudySites ON (dbo.vAccessibleSubjects.StudySiteID=dbo.StudySites.StudySiteID)
   INNER JOIN dbo.Studies ON (dbo.StudySites.StudyID=dbo.Studies.StudyID)
   INNER JOIN dbo.Projects ON (dbo.Studies.ProjectID=dbo.Projects.ProjectID)
   INNER JOIN dbo.LocalizedDataStrings  LocalizedDataStringsProjects ON ((dbo.Projects.ProjectName=LocalizedDataStringsProjects.StringID  and LocalizedDataStringsProjects.Locale='eng'))
   INNER JOIN dbo.Sites ON (dbo.StudySites.SiteID=dbo.Sites.SiteID)
   INNER JOIN dbo.SiteGroups ON (dbo.Sites.SiteGroupID=dbo.SiteGroups.SiteGroupID)
   INNER JOIN dbo.LocalizedDataStrings  LocalizedDataStringsSiteGroups ON ((LocalizedDataStringsSiteGroups.StringID=dbo.SiteGroups.SiteGroupNameID and LocalizedDataStringsSiteGroups.Locale='eng'))
   INNER JOIN dbo.LocalizedDataStrings  LocalizedDataStringsSites ON ((LocalizedDataStringsSites.StringID=dbo.Sites.SiteNameID AND LocalizedDataStringsSites.Locale='eng'))
   INNER JOIN dbo.SubjectStatus ON (dbo.SubjectStatus.SubjectStatusID=dbo.vAccessibleSubjects.SubjectStatus)
   INNER JOIN dbo.LocalizedDataStrings  LocalizedDataStringsSubjectStatus ON ((dbo.SubjectStatus.StringID=LocalizedDataStringsSubjectStatus.StringID  and LocalizedDataStringsSubjectStatus.Locale='eng'))
   INNER JOIN dbo.Fields ON (dbo.Fields.FieldID=dbo.vBODataPoints.FieldID)
   INNER JOIN dbo.Forms ON (dbo.Fields.FormID=dbo.Forms.FormID)
   INNER JOIN dbo.CRFVersions ON (dbo.CRFVersions.CRFVersionID=dbo.Forms.CRFVersionID)
   INNER JOIN dbo.LocalizedDataStrings ON ((dbo.LocalizedDataStrings.StringID=dbo.Forms.FormName and dbo.LocalizedDataStrings.Locale='eng'))
   INNER JOIN dbo.LocalizedDataStrings  LocalizedDataStringsFields ON ((dbo.Fields.FieldName=LocalizedDataStringsFields.StringID  and LocalizedDataStringsFields.Locale='eng'))
   LEFT OUTER JOIN dbo.MissingCodes ON (dbo.vBODataPoints.MissingCode=dbo.MissingCodes.MissingCodeID)
   LEFT OUTER JOIN dbo.LocalizedDataStrings  LocalizedDataStringsMC ON (dbo.MissingCodes.DescriptionID=LocalizedDataStringsMC.StringID)
  
WHERE
( dbo.vBODataPoints.IsHidden=0  )
  AND  ( (dbo.Sites.SiteActive=1 AND dbo.Sites.SiteID IN (SELECT SiteID FROM dbo.cfnRptStudyUserSites('593       2793      15        30618     ')))  )  AND  ( dbo.Studies.StudyActive=1
  AND  (dbo.Studies.StudyID=dbo.cfnBOSecurity('593       2793      15        30618     ',2) )  )  AND  ( dbo.vAccessibleSubjects.SubjectActive=1
  AND  dbo.vAccessibleSubjects.RoleID=dbo.cfnBOSecurity('593       2793      15        30618     ',3)  )  AND  ( (dbo.Forms.FormActive=1 AND dbo.Forms.IsDraft=0 AND dbo.Forms.FormID NOT IN (SELECT dbo.FormRestrictViews.FormID from dbo.FormRestrictViews  WHERE dbo.FormRestrictViews.RoleID=dbo.cfnBOSecurity('593       2793      15        30618     ',3)))  )  AND  ( (dbo.cv_Folders.ProjectID=dbo.cfnBOSecurity('593       2793      15        30618     ',1) OR dbo.cv_Folders.ProjectID IS NULL)  )  AND  ( (LocalizedDataStringsFolders.Locale='eng' OR LocalizedDataStringsFolders.Locale IS NULL)  )  AND  ( ((dbo.Instances.InstanceActive=1 or dbo.Instances.InstanceActive IS NULL) AND (dbo.Instances.Deleted IS NULL OR dbo.Instances.Deleted=0))  )  AND  ( (dbo.DataPages.DataPageActive=1  AND dbo.DataPages.Deleted =0)  )  AND  ( (dbo.CRFVersions.ProjectID=dbo.cfnBOSecurity('593       2793      15        30618     ',1) AND dbo.CRFVersions.IsDraft=0)  )  AND  ( (dbo.Records.RecordActive=1  AND dbo.Records.Deleted=0)  )  AND  ( (dbo.Fields.FieldActive=1 AND dbo.Fields.IsDraft=0 AND dbo.Fields.FieldID NOT IN (SELECT dbo.FieldRestrictViews.FieldID from dbo.FieldRestrictViews WHERE dbo.FieldRestrictViews.RoleID=dbo.cfnBOSecurity('593       2793      15        30618     ',3)))  )  AND  ( (dbo.vBODataPoints.DataActive=1  AND dbo.vBODataPoints.Deleted=0)
  AND  dbo.vBODataPoints.IsVisible=1  )  AND  ( ((dbo.MissingCodes.IsActive=1 OR dbo.MissingCodes.IsActive IS NULL) AND  (dbo.MissingCodes.Deleted=0 OR dbo.MissingCodes.Deleted IS NULL))  )  AND  ( (LocalizedDataStringsMC.Locale='eng' OR LocalizedDataStringsMC.Locale IS NULL)  )  AND  ( dbo.SubjectStatus.Deleted=0  )  AND  ( dbo.Projects.ProjectActive=1
  AND  (dbo.Projects.ProjectID=dbo.cfnBOSecurity('593       2793      15        30618     ',1))  )  AND  ( (dbo.SiteGroups.SiteGroupActive=1 And dbo.SiteGroups.Deleted=0)  )  AND  ( (dbo.StudySites.StudySiteActive=1 AND dbo.StudySites.Deleted=0)
  AND  dbo.StudySites.StudyID=dbo.cfnBOSecurity('593       2793      15        30618     ',2)  )
  AND  
  (
   dbo.fnFormatDataPageName(dbo.DataPages.DataPageName,dbo.DataPages.PageRepeatNumber,( dbo.LocalizedDataStrings.String ),( ISNULL(LocalizedDataStringsFolders.String,'Root Folder') ),dbo.Instances.InstanceRepeatNumber,dbo.vAccessibleSubjects.SubjectDate,dbo.DataPages.DataPageDate)  LIKE  N'%Inclusion/Exclusion%'
   AND
   dbo.Records.RecordID  In  
     (
     SELECT
       dbo.Records.RecordID
     FROM
       dbo.Records INNER JOIN dbo.vBODataPoints ON (dbo.vBODataPoints.RecordID=dbo.Records.RecordID)
        LEFT OUTER JOIN dbo.DataDictionaryEntries ON (dbo.vBODataPoints.DataDictEntryID=dbo.DataDictionaryEntries.DataDictionaryEntryID)
        INNER JOIN dbo.Fields ON (dbo.Fields.FieldID=dbo.vBODataPoints.FieldID)
        INNER JOIN dbo.Forms ON (dbo.Fields.FormID=dbo.Forms.FormID)
        INNER JOIN dbo.CRFVersions ON (dbo.CRFVersions.CRFVersionID=dbo.Forms.CRFVersionID)
        INNER JOIN dbo.LocalizedDataStrings  LocalizedDataStringsFields ON ((dbo.Fields.FieldName=LocalizedDataStringsFields.StringID  and LocalizedDataStringsFields.Locale='eng'))
        LEFT OUTER JOIN dbo.MissingCodes ON (dbo.vBODataPoints.MissingCode=dbo.MissingCodes.MissingCodeID)
        LEFT OUTER JOIN dbo.LocalizedDataStrings  LocalizedDataStringsMC ON (dbo.MissingCodes.DescriptionID=LocalizedDataStringsMC.StringID)
       
     WHERE
  ( (dbo.Records.RecordActive=1  AND dbo.Records.Deleted=0)  )  AND  ( (dbo.CRFVersions.ProjectID=dbo.cfnBOSecurity('593       2793      15        30618     ',1) AND dbo.CRFVersions.IsDraft=0)  )  AND  ( (dbo.Fields.FieldActive=1 AND dbo.Fields.IsDraft=0 AND dbo.Fields.FieldID NOT IN (SELECT dbo.FieldRestrictViews.FieldID from dbo.FieldRestrictViews WHERE dbo.FieldRestrictViews.RoleID=dbo.cfnBOSecurity('593       2793      15        30618     ',3)))  )  AND  ( (dbo.Forms.FormActive=1 AND dbo.Forms.IsDraft=0 AND dbo.Forms.FormID NOT IN (SELECT dbo.FormRestrictViews.FormID from dbo.FormRestrictViews  WHERE dbo.FormRestrictViews.RoleID=dbo.cfnBOSecurity('593       2793      15        30618     ',3)))  )  AND  ( (dbo.vBODataPoints.DataActive=1  AND dbo.vBODataPoints.Deleted=0)
  AND  dbo.vBODataPoints.IsVisible=1  )  AND  ( ((dbo.MissingCodes.IsActive=1 OR dbo.MissingCodes.IsActive IS NULL) AND  (dbo.MissingCodes.Deleted=0 OR dbo.MissingCodes.Deleted IS NULL))  )  AND  ( (LocalizedDataStringsMC.Locale='eng' OR LocalizedDataStringsMC.Locale IS NULL)  )
       AND  
       (
        LocalizedDataStringsFields.String  =  N'IEORRES'
        AND
        RTRIM((CASE WHEN (dbo.vBODataPoints.DataDictEntryID IS NOT NULL and  
dbo.DataDictionaryEntries.DataDictionaryEntryID=  
dbo.vBODataPoints.DataDictEntryID) then  
dbo.fnLocalDefault(dbo.DataDictionaryEntries.UserDataStringID)   
WHEN dbo.vBODataPoints.DataDictEntryID is null then RTRIM((CASE WHEN (dbo.vBODataPoints.MissingCode IS NOT NULL and  
dbo.MissingCodes.MissingCodeID=dbo.vBODataPoints.MissingCode) then  
(dbo.MissingCodes.MissingCode + ' - ''' + ISNULL(LocalizedDataStringsMC.String,'')+'''')   
ELSE dbo.vBODataPoints.Data  
END) )
END) )  =  N'Yes'
       AND  (dbo.vBODataPoints.IsHidden=0)
       )
     )
   AND
   LocalizedDataStringsSubjectStatus.String  <>  N'Screen Failure'
  )


SELECT
  LocalizedDataStringsSites.String,
  dbo.vAccessibleSubjects.SubjectNameForRole,
  dbo.fnFormatDataPageName(dbo.DataPages.DataPageName,dbo.DataPages.PageRepeatNumber,( dbo.LocalizedDataStrings.String ),( ISNULL(LocalizedDataStringsFolders.String,'Root Folder') ),dbo.Instances.InstanceRepeatNumber,dbo.vAccessibleSubjects.SubjectDate,dbo.DataPages.DataPageDate),
  dbo.fnFormatRecordName(dbo.Records.RecordName,dbo.Records.RecordPosition,( dbo.LocalizedDataStrings.String ),( ISNULL(LocalizedDataStringsFolders.String,'Root Folder') ),dbo.Instances.InstanceRepeatNumber, dbo.vAccessibleSubjects.SubjectDate,dbo.DataPages.DataPageDate,dbo.Records.RecordDate),
  dbo.Records.RecordPosition,
  LocalizedDataStringsFields.String,
  RTRIM((CASE WHEN (dbo.vBODataPoints.DataDictEntryID IS NOT NULL and  
dbo.DataDictionaryEntries.DataDictionaryEntryID=  
dbo.vBODataPoints.DataDictEntryID) then  
dbo.fnLocalDefault(dbo.DataDictionaryEntries.UserDataStringID)   
WHEN dbo.vBODataPoints.DataDictEntryID is null then RTRIM((CASE WHEN (dbo.vBODataPoints.MissingCode IS NOT NULL and  
dbo.MissingCodes.MissingCodeID=dbo.vBODataPoints.MissingCode) then  
(dbo.MissingCodes.MissingCode + ' - ''' + ISNULL(LocalizedDataStringsMC.String,'')+'''')   
ELSE dbo.vBODataPoints.Data  
END) )
END) ),
  dbo.Records.RecordID,
  dbo.Fields.SASLabel,
  LocalizedDataStringsSubjectStatus.String,
  LocalizedDataStringsProjects.String,
  LocalizedDataStringsSiteGroups.String
FROM
  dbo.DataDictionaryEntries RIGHT OUTER JOIN dbo.vBODataPoints ON (dbo.vBODataPoints.DataDictEntryID=dbo.DataDictionaryEntries.DataDictionaryEntryID)
   INNER JOIN dbo.Records ON (dbo.vBODataPoints.RecordID=dbo.Records.RecordID)
   LEFT OUTER JOIN dbo.Instances ON (dbo.Records.InstanceID=dbo.Instances.InstanceID)
   LEFT OUTER JOIN dbo.cv_Folders ON (dbo.cv_Folders.FolderID=dbo.Instances.FolderID)
   LEFT OUTER JOIN dbo.LocalizedDataStrings  LocalizedDataStringsFolders ON (dbo.cv_Folders.FolderName=LocalizedDataStringsFolders.StringID)
   INNER JOIN dbo.DataPages ON (dbo.Records.DataPageID=dbo.DataPages.DataPageID)
   INNER JOIN dbo.vAccessibleSubjects ON (dbo.vAccessibleSubjects.SubjectID=dbo.DataPages.SubjectID)
   INNER JOIN dbo.StudySites ON (dbo.vAccessibleSubjects.StudySiteID=dbo.StudySites.StudySiteID)
   INNER JOIN dbo.Studies ON (dbo.StudySites.StudyID=dbo.Studies.StudyID)
   INNER JOIN dbo.Projects ON (dbo.Studies.ProjectID=dbo.Projects.ProjectID)
   INNER JOIN dbo.LocalizedDataStrings  LocalizedDataStringsProjects ON ((dbo.Projects.ProjectName=LocalizedDataStringsProjects.StringID  and LocalizedDataStringsProjects.Locale='eng'))
   INNER JOIN dbo.Sites ON (dbo.StudySites.SiteID=dbo.Sites.SiteID)
   INNER JOIN dbo.SiteGroups ON (dbo.Sites.SiteGroupID=dbo.SiteGroups.SiteGroupID)
   INNER JOIN dbo.LocalizedDataStrings  LocalizedDataStringsSiteGroups ON ((LocalizedDataStringsSiteGroups.StringID=dbo.SiteGroups.SiteGroupNameID and LocalizedDataStringsSiteGroups.Locale='eng'))
   INNER JOIN dbo.LocalizedDataStrings  LocalizedDataStringsSites ON ((LocalizedDataStringsSites.StringID=dbo.Sites.SiteNameID AND LocalizedDataStringsSites.Locale='eng'))
   INNER JOIN dbo.SubjectStatus ON (dbo.SubjectStatus.SubjectStatusID=dbo.vAccessibleSubjects.SubjectStatus)
   INNER JOIN dbo.LocalizedDataStrings  LocalizedDataStringsSubjectStatus ON ((dbo.SubjectStatus.StringID=LocalizedDataStringsSubjectStatus.StringID  and LocalizedDataStringsSubjectStatus.Locale='eng'))
   INNER JOIN dbo.Fields ON (dbo.Fields.FieldID=dbo.vBODataPoints.FieldID)
   INNER JOIN dbo.Forms ON (dbo.Fields.FormID=dbo.Forms.FormID)
   INNER JOIN dbo.CRFVersions ON (dbo.CRFVersions.CRFVersionID=dbo.Forms.CRFVersionID)
   INNER JOIN dbo.LocalizedDataStrings ON ((dbo.LocalizedDataStrings.StringID=dbo.Forms.FormName and dbo.LocalizedDataStrings.Locale='eng'))
   INNER JOIN dbo.LocalizedDataStrings  LocalizedDataStringsFields ON ((dbo.Fields.FieldName=LocalizedDataStringsFields.StringID  and LocalizedDataStringsFields.Locale='eng'))
   LEFT OUTER JOIN dbo.MissingCodes ON (dbo.vBODataPoints.MissingCode=dbo.MissingCodes.MissingCodeID)
   LEFT OUTER JOIN dbo.LocalizedDataStrings  LocalizedDataStringsMC ON (dbo.MissingCodes.DescriptionID=LocalizedDataStringsMC.StringID)
  
WHERE
( dbo.vBODataPoints.IsHidden=0  )
  AND  ( (dbo.Sites.SiteActive=1 AND dbo.Sites.SiteID IN (SELECT SiteID FROM dbo.cfnRptStudyUserSites('593       2793      15        30618     ')))  )  AND  ( dbo.Studies.StudyActive=1
  AND  (dbo.Studies.StudyID=dbo.cfnBOSecurity('593       2793      15        30618     ',2) )  )  AND  ( dbo.vAccessibleSubjects.SubjectActive=1
  AND  dbo.vAccessibleSubjects.RoleID=dbo.cfnBOSecurity('593       2793      15        30618     ',3)  )  AND  ( (dbo.Forms.FormActive=1 AND dbo.Forms.IsDraft=0 AND dbo.Forms.FormID NOT IN (SELECT dbo.FormRestrictViews.FormID from dbo.FormRestrictViews  WHERE dbo.FormRestrictViews.RoleID=dbo.cfnBOSecurity('593       2793      15        30618     ',3)))  )  AND  ( (dbo.cv_Folders.ProjectID=dbo.cfnBOSecurity('593       2793      15        30618     ',1) OR dbo.cv_Folders.ProjectID IS NULL)  )  AND  ( (LocalizedDataStringsFolders.Locale='eng' OR LocalizedDataStringsFolders.Locale IS NULL)  )  AND  ( ((dbo.Instances.InstanceActive=1 or dbo.Instances.InstanceActive IS NULL) AND (dbo.Instances.Deleted IS NULL OR dbo.Instances.Deleted=0))  )  AND  ( (dbo.DataPages.DataPageActive=1  AND dbo.DataPages.Deleted =0)  )  AND  ( (dbo.CRFVersions.ProjectID=dbo.cfnBOSecurity('593       2793      15        30618     ',1) AND dbo.CRFVersions.IsDraft=0)  )  AND  ( (dbo.Records.RecordActive=1  AND dbo.Records.Deleted=0)  )  AND  ( (dbo.Fields.FieldActive=1 AND dbo.Fields.IsDraft=0 AND dbo.Fields.FieldID NOT IN (SELECT dbo.FieldRestrictViews.FieldID from dbo.FieldRestrictViews WHERE dbo.FieldRestrictViews.RoleID=dbo.cfnBOSecurity('593       2793      15        30618     ',3)))  )  AND  ( (dbo.vBODataPoints.DataActive=1  AND dbo.vBODataPoints.Deleted=0)
  AND  dbo.vBODataPoints.IsVisible=1  )  AND  ( ((dbo.MissingCodes.IsActive=1 OR dbo.MissingCodes.IsActive IS NULL) AND  (dbo.MissingCodes.Deleted=0 OR dbo.MissingCodes.Deleted IS NULL))  )  AND  ( (LocalizedDataStringsMC.Locale='eng' OR LocalizedDataStringsMC.Locale IS NULL)  )  AND  ( dbo.SubjectStatus.Deleted=0  )  AND  ( dbo.Projects.ProjectActive=1
  AND  (dbo.Projects.ProjectID=dbo.cfnBOSecurity('593       2793      15        30618     ',1))  )  AND  ( (dbo.SiteGroups.SiteGroupActive=1 And dbo.SiteGroups.Deleted=0)  )  AND  ( (dbo.StudySites.StudySiteActive=1 AND dbo.StudySites.Deleted=0)
  AND  dbo.StudySites.StudyID=dbo.cfnBOSecurity('593       2793      15        30618     ',2)  )
  AND  
  (
   dbo.fnFormatDataPageName(dbo.DataPages.DataPageName,dbo.DataPages.PageRepeatNumber,( dbo.LocalizedDataStrings.String ),( ISNULL(LocalizedDataStringsFolders.String,'Root Folder') ),dbo.Instances.InstanceRepeatNumber,dbo.vAccessibleSubjects.SubjectDate,dbo.DataPages.DataPageDate)  LIKE  N'%Inclusion/Exclusion%'
   AND
   dbo.Records.RecordID  In  
     (
     SELECT
       dbo.Records.RecordID
     FROM
       dbo.Records INNER JOIN dbo.vBODataPoints ON (dbo.vBODataPoints.RecordID=dbo.Records.RecordID)
        LEFT OUTER JOIN dbo.DataDictionaryEntries ON (dbo.vBODataPoints.DataDictEntryID=dbo.DataDictionaryEntries.DataDictionaryEntryID)
        INNER JOIN dbo.Fields ON (dbo.Fields.FieldID=dbo.vBODataPoints.FieldID)
        INNER JOIN dbo.Forms ON (dbo.Fields.FormID=dbo.Forms.FormID)
        INNER JOIN dbo.CRFVersions ON (dbo.CRFVersions.CRFVersionID=dbo.Forms.CRFVersionID)
        INNER JOIN dbo.LocalizedDataStrings  LocalizedDataStringsFields ON ((dbo.Fields.FieldName=LocalizedDataStringsFields.StringID  and LocalizedDataStringsFields.Locale='eng'))
        LEFT OUTER JOIN dbo.MissingCodes ON (dbo.vBODataPoints.MissingCode=dbo.MissingCodes.MissingCodeID)
        LEFT OUTER JOIN dbo.LocalizedDataStrings  LocalizedDataStringsMC ON (dbo.MissingCodes.DescriptionID=LocalizedDataStringsMC.StringID)
       
     WHERE
  ( (dbo.Records.RecordActive=1  AND dbo.Records.Deleted=0)  )  AND  ( (dbo.CRFVersions.ProjectID=dbo.cfnBOSecurity('593       2793      15        30618     ',1) AND dbo.CRFVersions.IsDraft=0)  )  AND  ( (dbo.Fields.FieldActive=1 AND dbo.Fields.IsDraft=0 AND dbo.Fields.FieldID NOT IN (SELECT dbo.FieldRestrictViews.FieldID from dbo.FieldRestrictViews WHERE dbo.FieldRestrictViews.RoleID=dbo.cfnBOSecurity('593       2793      15        30618     ',3)))  )  AND  ( (dbo.Forms.FormActive=1 AND dbo.Forms.IsDraft=0 AND dbo.Forms.FormID NOT IN (SELECT dbo.FormRestrictViews.FormID from dbo.FormRestrictViews  WHERE dbo.FormRestrictViews.RoleID=dbo.cfnBOSecurity('593       2793      15        30618     ',3)))  )  AND  ( (dbo.vBODataPoints.DataActive=1  AND dbo.vBODataPoints.Deleted=0)
  AND  dbo.vBODataPoints.IsVisible=1  )  AND  ( ((dbo.MissingCodes.IsActive=1 OR dbo.MissingCodes.IsActive IS NULL) AND  (dbo.MissingCodes.Deleted=0 OR dbo.MissingCodes.Deleted IS NULL))  )  AND  ( (LocalizedDataStringsMC.Locale='eng' OR LocalizedDataStringsMC.Locale IS NULL)  )
       AND  
       (
        LocalizedDataStringsFields.String  =  N'IETESTCD'
        AND
        RTRIM((CASE WHEN (dbo.vBODataPoints.DataDictEntryID IS NOT NULL and  
dbo.DataDictionaryEntries.DataDictionaryEntryID=  
dbo.vBODataPoints.DataDictEntryID) then  
dbo.fnLocalDefault(dbo.DataDictionaryEntries.UserDataStringID)   
WHEN dbo.vBODataPoints.DataDictEntryID is null then RTRIM((CASE WHEN (dbo.vBODataPoints.MissingCode IS NOT NULL and  
dbo.MissingCodes.MissingCodeID=dbo.vBODataPoints.MissingCode) then  
(dbo.MissingCodes.MissingCode + ' - ''' + ISNULL(LocalizedDataStringsMC.String,'')+'''')   
ELSE dbo.vBODataPoints.Data  
END) )
END) )  LIKE  N'%Excl%'
       AND  (dbo.vBODataPoints.IsHidden=0)
       )
     )
   AND
   LocalizedDataStringsSubjectStatus.String  <>  N'Screen Failure'
  )


SELECT
  LocalizedDataStringsSites.String,
  dbo.vAccessibleSubjects.SubjectNameForRole,
  dbo.fnFormatDataPageName(dbo.DataPages.DataPageName,dbo.DataPages.PageRepeatNumber,( dbo.LocalizedDataStrings.String ),( ISNULL(LocalizedDataStringsFolders.String,'Root Folder') ),dbo.Instances.InstanceRepeatNumber,dbo.vAccessibleSubjects.SubjectDate,dbo.DataPages.DataPageDate),
  dbo.fnFormatRecordName(dbo.Records.RecordName,dbo.Records.RecordPosition,( dbo.LocalizedDataStrings.String ),( ISNULL(LocalizedDataStringsFolders.String,'Root Folder') ),dbo.Instances.InstanceRepeatNumber, dbo.vAccessibleSubjects.SubjectDate,dbo.DataPages.DataPageDate,dbo.Records.RecordDate),
  dbo.Records.RecordPosition,
  LocalizedDataStringsFields.String,
  RTRIM((CASE WHEN (dbo.vBODataPoints.DataDictEntryID IS NOT NULL and  
dbo.DataDictionaryEntries.DataDictionaryEntryID=  
dbo.vBODataPoints.DataDictEntryID) then  
dbo.fnLocalDefault(dbo.DataDictionaryEntries.UserDataStringID)   
WHEN dbo.vBODataPoints.DataDictEntryID is null then RTRIM((CASE WHEN (dbo.vBODataPoints.MissingCode IS NOT NULL and  
dbo.MissingCodes.MissingCodeID=dbo.vBODataPoints.MissingCode) then  
(dbo.MissingCodes.MissingCode + ' - ''' + ISNULL(LocalizedDataStringsMC.String,'')+'''')   
ELSE dbo.vBODataPoints.Data  
END) )
END) ),
  dbo.Records.RecordID,
  dbo.Fields.SASLabel,
  LocalizedDataStringsSubjectStatus.String,
  LocalizedDataStringsProjects.String,
  LocalizedDataStringsSiteGroups.String
FROM
  dbo.DataDictionaryEntries RIGHT OUTER JOIN dbo.vBODataPoints ON (dbo.vBODataPoints.DataDictEntryID=dbo.DataDictionaryEntries.DataDictionaryEntryID)
   INNER JOIN dbo.Records ON (dbo.vBODataPoints.RecordID=dbo.Records.RecordID)
   LEFT OUTER JOIN dbo.Instances ON (dbo.Records.InstanceID=dbo.Instances.InstanceID)
   LEFT OUTER JOIN dbo.cv_Folders ON (dbo.cv_Folders.FolderID=dbo.Instances.FolderID)
   LEFT OUTER JOIN dbo.LocalizedDataStrings  LocalizedDataStringsFolders ON (dbo.cv_Folders.FolderName=LocalizedDataStringsFolders.StringID)
   INNER JOIN dbo.DataPages ON (dbo.Records.DataPageID=dbo.DataPages.DataPageID)
   INNER JOIN dbo.vAccessibleSubjects ON (dbo.vAccessibleSubjects.SubjectID=dbo.DataPages.SubjectID)
   INNER JOIN dbo.StudySites ON (dbo.vAccessibleSubjects.StudySiteID=dbo.StudySites.StudySiteID)
   INNER JOIN dbo.Studies ON (dbo.StudySites.StudyID=dbo.Studies.StudyID)
   INNER JOIN dbo.Projects ON (dbo.Studies.ProjectID=dbo.Projects.ProjectID)
   INNER JOIN dbo.LocalizedDataStrings  LocalizedDataStringsProjects ON ((dbo.Projects.ProjectName=LocalizedDataStringsProjects.StringID  and LocalizedDataStringsProjects.Locale='eng'))
   INNER JOIN dbo.Sites ON (dbo.StudySites.SiteID=dbo.Sites.SiteID)
   INNER JOIN dbo.SiteGroups ON (dbo.Sites.SiteGroupID=dbo.SiteGroups.SiteGroupID)
   INNER JOIN dbo.LocalizedDataStrings  LocalizedDataStringsSiteGroups ON ((LocalizedDataStringsSiteGroups.StringID=dbo.SiteGroups.SiteGroupNameID and LocalizedDataStringsSiteGroups.Locale='eng'))
   INNER JOIN dbo.LocalizedDataStrings  LocalizedDataStringsSites ON ((LocalizedDataStringsSites.StringID=dbo.Sites.SiteNameID AND LocalizedDataStringsSites.Locale='eng'))
   INNER JOIN dbo.SubjectStatus ON (dbo.SubjectStatus.SubjectStatusID=dbo.vAccessibleSubjects.SubjectStatus)
   INNER JOIN dbo.LocalizedDataStrings  LocalizedDataStringsSubjectStatus ON ((dbo.SubjectStatus.StringID=LocalizedDataStringsSubjectStatus.StringID  and LocalizedDataStringsSubjectStatus.Locale='eng'))
   INNER JOIN dbo.Fields ON (dbo.Fields.FieldID=dbo.vBODataPoints.FieldID)
   INNER JOIN dbo.Forms ON (dbo.Fields.FormID=dbo.Forms.FormID)
   INNER JOIN dbo.CRFVersions ON (dbo.CRFVersions.CRFVersionID=dbo.Forms.CRFVersionID)
   INNER JOIN dbo.LocalizedDataStrings ON ((dbo.LocalizedDataStrings.StringID=dbo.Forms.FormName and dbo.LocalizedDataStrings.Locale='eng'))
   INNER JOIN dbo.LocalizedDataStrings  LocalizedDataStringsFields ON ((dbo.Fields.FieldName=LocalizedDataStringsFields.StringID  and LocalizedDataStringsFields.Locale='eng'))
   LEFT OUTER JOIN dbo.MissingCodes ON (dbo.vBODataPoints.MissingCode=dbo.MissingCodes.MissingCodeID)
   LEFT OUTER JOIN dbo.LocalizedDataStrings  LocalizedDataStringsMC ON (dbo.MissingCodes.DescriptionID=LocalizedDataStringsMC.StringID)
  
WHERE
( dbo.vBODataPoints.IsHidden=0  )
  AND  ( (dbo.Sites.SiteActive=1 AND dbo.Sites.SiteID IN (SELECT SiteID FROM dbo.cfnRptStudyUserSites('593       2793      15        30618     ')))  )  AND  ( dbo.Studies.StudyActive=1
  AND  (dbo.Studies.StudyID=dbo.cfnBOSecurity('593       2793      15        30618     ',2) )  )  AND  ( dbo.vAccessibleSubjects.SubjectActive=1
  AND  dbo.vAccessibleSubjects.RoleID=dbo.cfnBOSecurity('593       2793      15        30618     ',3)  )  AND  ( (dbo.Forms.FormActive=1 AND dbo.Forms.IsDraft=0 AND dbo.Forms.FormID NOT IN (SELECT dbo.FormRestrictViews.FormID from dbo.FormRestrictViews  WHERE dbo.FormRestrictViews.RoleID=dbo.cfnBOSecurity('593       2793      15        30618     ',3)))  )  AND  ( (dbo.cv_Folders.ProjectID=dbo.cfnBOSecurity('593       2793      15        30618     ',1) OR dbo.cv_Folders.ProjectID IS NULL)  )  AND  ( (LocalizedDataStringsFolders.Locale='eng' OR LocalizedDataStringsFolders.Locale IS NULL)  )  AND  ( ((dbo.Instances.InstanceActive=1 or dbo.Instances.InstanceActive IS NULL) AND (dbo.Instances.Deleted IS NULL OR dbo.Instances.Deleted=0))  )  AND  ( (dbo.DataPages.DataPageActive=1  AND dbo.DataPages.Deleted =0)  )  AND  ( (dbo.CRFVersions.ProjectID=dbo.cfnBOSecurity('593       2793      15        30618     ',1) AND dbo.CRFVersions.IsDraft=0)  )  AND  ( (dbo.Records.RecordActive=1  AND dbo.Records.Deleted=0)  )  AND  ( (dbo.Fields.FieldActive=1 AND dbo.Fields.IsDraft=0 AND dbo.Fields.FieldID NOT IN (SELECT dbo.FieldRestrictViews.FieldID from dbo.FieldRestrictViews WHERE dbo.FieldRestrictViews.RoleID=dbo.cfnBOSecurity('593       2793      15        30618     ',3)))  )  AND  ( (dbo.vBODataPoints.DataActive=1  AND dbo.vBODataPoints.Deleted=0)
  AND  dbo.vBODataPoints.IsVisible=1  )  AND  ( ((dbo.MissingCodes.IsActive=1 OR dbo.MissingCodes.IsActive IS NULL) AND  (dbo.MissingCodes.Deleted=0 OR dbo.MissingCodes.Deleted IS NULL))  )  AND  ( (LocalizedDataStringsMC.Locale='eng' OR LocalizedDataStringsMC.Locale IS NULL)  )  AND  ( dbo.SubjectStatus.Deleted=0  )  AND  ( dbo.Projects.ProjectActive=1
  AND  (dbo.Projects.ProjectID=dbo.cfnBOSecurity('593       2793      15        30618     ',1))  )  AND  ( (dbo.SiteGroups.SiteGroupActive=1 And dbo.SiteGroups.Deleted=0)  )  AND  ( (dbo.StudySites.StudySiteActive=1 AND dbo.StudySites.Deleted=0)
  AND  dbo.StudySites.StudyID=dbo.cfnBOSecurity('593       2793      15        30618     ',2)  )
  AND  
  (
   dbo.fnFormatDataPageName(dbo.DataPages.DataPageName,dbo.DataPages.PageRepeatNumber,( dbo.LocalizedDataStrings.String ),( ISNULL(LocalizedDataStringsFolders.String,'Root Folder') ),dbo.Instances.InstanceRepeatNumber,dbo.vAccessibleSubjects.SubjectDate,dbo.DataPages.DataPageDate)  LIKE  N'%Inclusion/Exclusion%'
   AND
   dbo.Records.RecordID  In  
     (
     SELECT
       dbo.Records.RecordID
     FROM
       dbo.Records INNER JOIN dbo.vBODataPoints ON (dbo.vBODataPoints.RecordID=dbo.Records.RecordID)
        LEFT OUTER JOIN dbo.DataDictionaryEntries ON (dbo.vBODataPoints.DataDictEntryID=dbo.DataDictionaryEntries.DataDictionaryEntryID)
        INNER JOIN dbo.Fields ON (dbo.Fields.FieldID=dbo.vBODataPoints.FieldID)
        INNER JOIN dbo.Forms ON (dbo.Fields.FormID=dbo.Forms.FormID)
        INNER JOIN dbo.CRFVersions ON (dbo.CRFVersions.CRFVersionID=dbo.Forms.CRFVersionID)
        INNER JOIN dbo.LocalizedDataStrings  LocalizedDataStringsFields ON ((dbo.Fields.FieldName=LocalizedDataStringsFields.StringID  and LocalizedDataStringsFields.Locale='eng'))
        LEFT OUTER JOIN dbo.MissingCodes ON (dbo.vBODataPoints.MissingCode=dbo.MissingCodes.MissingCodeID)
        LEFT OUTER JOIN dbo.LocalizedDataStrings  LocalizedDataStringsMC ON (dbo.MissingCodes.DescriptionID=LocalizedDataStringsMC.StringID)
       
     WHERE
  ( (dbo.Records.RecordActive=1  AND dbo.Records.Deleted=0)  )  AND  ( (dbo.CRFVersions.ProjectID=dbo.cfnBOSecurity('593       2793      15        30618     ',1) AND dbo.CRFVersions.IsDraft=0)  )  AND  ( (dbo.Fields.FieldActive=1 AND dbo.Fields.IsDraft=0 AND dbo.Fields.FieldID NOT IN (SELECT dbo.FieldRestrictViews.FieldID from dbo.FieldRestrictViews WHERE dbo.FieldRestrictViews.RoleID=dbo.cfnBOSecurity('593       2793      15        30618     ',3)))  )  AND  ( (dbo.Forms.FormActive=1 AND dbo.Forms.IsDraft=0 AND dbo.Forms.FormID NOT IN (SELECT dbo.FormRestrictViews.FormID from dbo.FormRestrictViews  WHERE dbo.FormRestrictViews.RoleID=dbo.cfnBOSecurity('593       2793      15        30618     ',3)))  )  AND  ( (dbo.vBODataPoints.DataActive=1  AND dbo.vBODataPoints.Deleted=0)
  AND  dbo.vBODataPoints.IsVisible=1  )  AND  ( ((dbo.MissingCodes.IsActive=1 OR dbo.MissingCodes.IsActive IS NULL) AND  (dbo.MissingCodes.Deleted=0 OR dbo.MissingCodes.Deleted IS NULL))  )  AND  ( (LocalizedDataStringsMC.Locale='eng' OR LocalizedDataStringsMC.Locale IS NULL)  )
       AND  
       (
        LocalizedDataStringsFields.String  =  N'IEORRES'
        AND
        RTRIM((CASE WHEN (dbo.vBODataPoints.DataDictEntryID IS NOT NULL and  
dbo.DataDictionaryEntries.DataDictionaryEntryID=  
dbo.vBODataPoints.DataDictEntryID) then  
dbo.fnLocalDefault(dbo.DataDictionaryEntries.UserDataStringID)   
WHEN dbo.vBODataPoints.DataDictEntryID is null then RTRIM((CASE WHEN (dbo.vBODataPoints.MissingCode IS NOT NULL and  
dbo.MissingCodes.MissingCodeID=dbo.vBODataPoints.MissingCode) then  
(dbo.MissingCodes.MissingCode + ' - ''' + ISNULL(LocalizedDataStringsMC.String,'')+'''')   
ELSE dbo.vBODataPoints.Data  
END) )
END) )  =  N'No'
       AND  (dbo.vBODataPoints.IsHidden=0)
       )
     )
   AND
   LocalizedDataStringsSubjectStatus.String  <>  N'Screen Failure'
  )


SELECT
  LocalizedDataStringsSites.String,
  dbo.vAccessibleSubjects.SubjectNameForRole,
  dbo.fnFormatDataPageName(dbo.DataPages.DataPageName,dbo.DataPages.PageRepeatNumber,( dbo.LocalizedDataStrings.String ),( ISNULL(LocalizedDataStringsFolders.String,'Root Folder') ),dbo.Instances.InstanceRepeatNumber,dbo.vAccessibleSubjects.SubjectDate,dbo.DataPages.DataPageDate),
  dbo.fnFormatRecordName(dbo.Records.RecordName,dbo.Records.RecordPosition,( dbo.LocalizedDataStrings.String ),( ISNULL(LocalizedDataStringsFolders.String,'Root Folder') ),dbo.Instances.InstanceRepeatNumber, dbo.vAccessibleSubjects.SubjectDate,dbo.DataPages.DataPageDate,dbo.Records.RecordDate),
  dbo.Records.RecordPosition,
  LocalizedDataStringsFields.String,
  RTRIM((CASE WHEN (dbo.vBODataPoints.DataDictEntryID IS NOT NULL and  
dbo.DataDictionaryEntries.DataDictionaryEntryID=  
dbo.vBODataPoints.DataDictEntryID) then  
dbo.fnLocalDefault(dbo.DataDictionaryEntries.UserDataStringID)   
WHEN dbo.vBODataPoints.DataDictEntryID is null then RTRIM((CASE WHEN (dbo.vBODataPoints.MissingCode IS NOT NULL and  
dbo.MissingCodes.MissingCodeID=dbo.vBODataPoints.MissingCode) then  
(dbo.MissingCodes.MissingCode + ' - ''' + ISNULL(LocalizedDataStringsMC.String,'')+'''')   
ELSE dbo.vBODataPoints.Data  
END) )
END) ),
  dbo.Records.RecordID,
  dbo.Fields.SASLabel,
  LocalizedDataStringsSubjectStatus.String,
  LocalizedDataStringsProjects.String,
  LocalizedDataStringsSiteGroups.String
FROM
  dbo.DataDictionaryEntries RIGHT OUTER JOIN dbo.vBODataPoints ON (dbo.vBODataPoints.DataDictEntryID=dbo.DataDictionaryEntries.DataDictionaryEntryID)
   INNER JOIN dbo.Records ON (dbo.vBODataPoints.RecordID=dbo.Records.RecordID)
   LEFT OUTER JOIN dbo.Instances ON (dbo.Records.InstanceID=dbo.Instances.InstanceID)
   LEFT OUTER JOIN dbo.cv_Folders ON (dbo.cv_Folders.FolderID=dbo.Instances.FolderID)
   LEFT OUTER JOIN dbo.LocalizedDataStrings  LocalizedDataStringsFolders ON (dbo.cv_Folders.FolderName=LocalizedDataStringsFolders.StringID)
   INNER JOIN dbo.DataPages ON (dbo.Records.DataPageID=dbo.DataPages.DataPageID)
   INNER JOIN dbo.vAccessibleSubjects ON (dbo.vAccessibleSubjects.SubjectID=dbo.DataPages.SubjectID)
   INNER JOIN dbo.StudySites ON (dbo.vAccessibleSubjects.StudySiteID=dbo.StudySites.StudySiteID)
   INNER JOIN dbo.Studies ON (dbo.StudySites.StudyID=dbo.Studies.StudyID)
   INNER JOIN dbo.Projects ON (dbo.Studies.ProjectID=dbo.Projects.ProjectID)
   INNER JOIN dbo.LocalizedDataStrings  LocalizedDataStringsProjects ON ((dbo.Projects.ProjectName=LocalizedDataStringsProjects.StringID  and LocalizedDataStringsProjects.Locale='eng'))
   INNER JOIN dbo.Sites ON (dbo.StudySites.SiteID=dbo.Sites.SiteID)
   INNER JOIN dbo.SiteGroups ON (dbo.Sites.SiteGroupID=dbo.SiteGroups.SiteGroupID)
   INNER JOIN dbo.LocalizedDataStrings  LocalizedDataStringsSiteGroups ON ((LocalizedDataStringsSiteGroups.StringID=dbo.SiteGroups.SiteGroupNameID and LocalizedDataStringsSiteGroups.Locale='eng'))
   INNER JOIN dbo.LocalizedDataStrings  LocalizedDataStringsSites ON ((LocalizedDataStringsSites.StringID=dbo.Sites.SiteNameID AND LocalizedDataStringsSites.Locale='eng'))
   INNER JOIN dbo.SubjectStatus ON (dbo.SubjectStatus.SubjectStatusID=dbo.vAccessibleSubjects.SubjectStatus)
   INNER JOIN dbo.LocalizedDataStrings  LocalizedDataStringsSubjectStatus ON ((dbo.SubjectStatus.StringID=LocalizedDataStringsSubjectStatus.StringID  and LocalizedDataStringsSubjectStatus.Locale='eng'))
   INNER JOIN dbo.Fields ON (dbo.Fields.FieldID=dbo.vBODataPoints.FieldID)
   INNER JOIN dbo.Forms ON (dbo.Fields.FormID=dbo.Forms.FormID)
   INNER JOIN dbo.CRFVersions ON (dbo.CRFVersions.CRFVersionID=dbo.Forms.CRFVersionID)
   INNER JOIN dbo.LocalizedDataStrings ON ((dbo.LocalizedDataStrings.StringID=dbo.Forms.FormName and dbo.LocalizedDataStrings.Locale='eng'))
   INNER JOIN dbo.LocalizedDataStrings  LocalizedDataStringsFields ON ((dbo.Fields.FieldName=LocalizedDataStringsFields.StringID  and LocalizedDataStringsFields.Locale='eng'))
   LEFT OUTER JOIN dbo.MissingCodes ON (dbo.vBODataPoints.MissingCode=dbo.MissingCodes.MissingCodeID)
   LEFT OUTER JOIN dbo.LocalizedDataStrings  LocalizedDataStringsMC ON (dbo.MissingCodes.DescriptionID=LocalizedDataStringsMC.StringID)
  
WHERE
( dbo.vBODataPoints.IsHidden=0  )
  AND  ( (dbo.Sites.SiteActive=1 AND dbo.Sites.SiteID IN (SELECT SiteID FROM dbo.cfnRptStudyUserSites('593       2793      15        30618     ')))  )  AND  ( dbo.Studies.StudyActive=1
  AND  (dbo.Studies.StudyID=dbo.cfnBOSecurity('593       2793      15        30618     ',2) )  )  AND  ( dbo.vAccessibleSubjects.SubjectActive=1
  AND  dbo.vAccessibleSubjects.RoleID=dbo.cfnBOSecurity('593       2793      15        30618     ',3)  )  AND  ( (dbo.Forms.FormActive=1 AND dbo.Forms.IsDraft=0 AND dbo.Forms.FormID NOT IN (SELECT dbo.FormRestrictViews.FormID from dbo.FormRestrictViews  WHERE dbo.FormRestrictViews.RoleID=dbo.cfnBOSecurity('593       2793      15        30618     ',3)))  )  AND  ( (dbo.cv_Folders.ProjectID=dbo.cfnBOSecurity('593       2793      15        30618     ',1) OR dbo.cv_Folders.ProjectID IS NULL)  )  AND  ( (LocalizedDataStringsFolders.Locale='eng' OR LocalizedDataStringsFolders.Locale IS NULL)  )  AND  ( ((dbo.Instances.InstanceActive=1 or dbo.Instances.InstanceActive IS NULL) AND (dbo.Instances.Deleted IS NULL OR dbo.Instances.Deleted=0))  )  AND  ( (dbo.DataPages.DataPageActive=1  AND dbo.DataPages.Deleted =0)  )  AND  ( (dbo.CRFVersions.ProjectID=dbo.cfnBOSecurity('593       2793      15        30618     ',1) AND dbo.CRFVersions.IsDraft=0)  )  AND  ( (dbo.Records.RecordActive=1  AND dbo.Records.Deleted=0)  )  AND  ( (dbo.Fields.FieldActive=1 AND dbo.Fields.IsDraft=0 AND dbo.Fields.FieldID NOT IN (SELECT dbo.FieldRestrictViews.FieldID from dbo.FieldRestrictViews WHERE dbo.FieldRestrictViews.RoleID=dbo.cfnBOSecurity('593       2793      15        30618     ',3)))  )  AND  ( (dbo.vBODataPoints.DataActive=1  AND dbo.vBODataPoints.Deleted=0)
  AND  dbo.vBODataPoints.IsVisible=1  )  AND  ( ((dbo.MissingCodes.IsActive=1 OR dbo.MissingCodes.IsActive IS NULL) AND  (dbo.MissingCodes.Deleted=0 OR dbo.MissingCodes.Deleted IS NULL))  )  AND  ( (LocalizedDataStringsMC.Locale='eng' OR LocalizedDataStringsMC.Locale IS NULL)  )  AND  ( dbo.SubjectStatus.Deleted=0  )  AND  ( dbo.Projects.ProjectActive=1
  AND  (dbo.Projects.ProjectID=dbo.cfnBOSecurity('593       2793      15        30618     ',1))  )  AND  ( (dbo.SiteGroups.SiteGroupActive=1 And dbo.SiteGroups.Deleted=0)  )  AND  ( (dbo.StudySites.StudySiteActive=1 AND dbo.StudySites.Deleted=0)
  AND  dbo.StudySites.StudyID=dbo.cfnBOSecurity('593       2793      15        30618     ',2)  )
  AND  
  (
   dbo.fnFormatDataPageName(dbo.DataPages.DataPageName,dbo.DataPages.PageRepeatNumber,( dbo.LocalizedDataStrings.String ),( ISNULL(LocalizedDataStringsFolders.String,'Root Folder') ),dbo.Instances.InstanceRepeatNumber,dbo.vAccessibleSubjects.SubjectDate,dbo.DataPages.DataPageDate)  LIKE  N'%Inclusion/Exclusion%'
   AND
   dbo.Records.RecordID  In  
     (
     SELECT
       dbo.Records.RecordID
     FROM
       dbo.Records INNER JOIN dbo.vBODataPoints ON (dbo.vBODataPoints.RecordID=dbo.Records.RecordID)
        LEFT OUTER JOIN dbo.DataDictionaryEntries ON (dbo.vBODataPoints.DataDictEntryID=dbo.DataDictionaryEntries.DataDictionaryEntryID)
        INNER JOIN dbo.Fields ON (dbo.Fields.FieldID=dbo.vBODataPoints.FieldID)
        INNER JOIN dbo.Forms ON (dbo.Fields.FormID=dbo.Forms.FormID)
        INNER JOIN dbo.CRFVersions ON (dbo.CRFVersions.CRFVersionID=dbo.Forms.CRFVersionID)
        INNER JOIN dbo.LocalizedDataStrings  LocalizedDataStringsFields ON ((dbo.Fields.FieldName=LocalizedDataStringsFields.StringID  and LocalizedDataStringsFields.Locale='eng'))
        LEFT OUTER JOIN dbo.MissingCodes ON (dbo.vBODataPoints.MissingCode=dbo.MissingCodes.MissingCodeID)
        LEFT OUTER JOIN dbo.LocalizedDataStrings  LocalizedDataStringsMC ON (dbo.MissingCodes.DescriptionID=LocalizedDataStringsMC.StringID)
       
     WHERE
  ( (dbo.Records.RecordActive=1  AND dbo.Records.Deleted=0)  )  AND  ( (dbo.CRFVersions.ProjectID=dbo.cfnBOSecurity('593       2793      15        30618     ',1) AND dbo.CRFVersions.IsDraft=0)  )  AND  ( (dbo.Fields.FieldActive=1 AND dbo.Fields.IsDraft=0 AND dbo.Fields.FieldID NOT IN (SELECT dbo.FieldRestrictViews.FieldID from dbo.FieldRestrictViews WHERE dbo.FieldRestrictViews.RoleID=dbo.cfnBOSecurity('593       2793      15        30618     ',3)))  )  AND  ( (dbo.Forms.FormActive=1 AND dbo.Forms.IsDraft=0 AND dbo.Forms.FormID NOT IN (SELECT dbo.FormRestrictViews.FormID from dbo.FormRestrictViews  WHERE dbo.FormRestrictViews.RoleID=dbo.cfnBOSecurity('593       2793      15        30618     ',3)))  )  AND  ( (dbo.vBODataPoints.DataActive=1  AND dbo.vBODataPoints.Deleted=0)
  AND  dbo.vBODataPoints.IsVisible=1  )  AND  ( ((dbo.MissingCodes.IsActive=1 OR dbo.MissingCodes.IsActive IS NULL) AND  (dbo.MissingCodes.Deleted=0 OR dbo.MissingCodes.Deleted IS NULL))  )  AND  ( (LocalizedDataStringsMC.Locale='eng' OR LocalizedDataStringsMC.Locale IS NULL)  )
       AND  
       (
        LocalizedDataStringsFields.String  =  N'IETESTCD'
        AND
        RTRIM((CASE WHEN (dbo.vBODataPoints.DataDictEntryID IS NOT NULL and  
dbo.DataDictionaryEntries.DataDictionaryEntryID=  
dbo.vBODataPoints.DataDictEntryID) then  
dbo.fnLocalDefault(dbo.DataDictionaryEntries.UserDataStringID)   
WHEN dbo.vBODataPoints.DataDictEntryID is null then RTRIM((CASE WHEN (dbo.vBODataPoints.MissingCode IS NOT NULL and  
dbo.MissingCodes.MissingCodeID=dbo.vBODataPoints.MissingCode) then  
(dbo.MissingCodes.MissingCode + ' - ''' + ISNULL(LocalizedDataStringsMC.String,'')+'''')   
ELSE dbo.vBODataPoints.Data  
END) )
END) )  LIKE  N'%Incl%'
       AND  (dbo.vBODataPoints.IsHidden=0)
       )
     )
   AND
   LocalizedDataStringsSubjectStatus.String  <>  N'Screen Failure'
  )


