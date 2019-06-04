if("${QEVERCLOUD_FIND_PACKAGE_ARG}" STREQUAL "")
  set(QEVERCLOUD_FIND_PACKAGE_ARG "QUIET")
else()
  set(QEVERCLOUD_FIND_PACKAGE_ARG "")
endif()

QEverCloudFindPackageWrapper(Qt5Core ${QEVERCLOUD_FIND_PACKAGE_ARG})
QEverCloudFindPackageWrapper(Qt5Network ${QEVERCLOUD_FIND_PACKAGE_ARG})
QEverCloudFindPackageWrapper(Qt5Widgets ${QEVERCLOUD_FIND_PACKAGE_ARG})
