# CentredCellCollectionView

Easy way to create collection view with center item center.


Logic behind 

 
/*
     *
     |<-------     view width     -------->|
     ---------------------------------------
     |                                     |
     |<-w0->|<ws>|<--   wi  -->|<ws>|<-w0->|
     ---------------    ---------------    ---------------
     |             |    |             |    |             |
     |             |    |             |    |             |
     ---------------    ---------------    ---------------
     |                                     |
     |                                     |
     ---------------------------------------
     *
     * w0: itemEdgeOffset
     * ws: space
     * wi: itemWidth
     * in this example: ws == w0
     */
