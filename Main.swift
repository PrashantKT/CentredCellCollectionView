class WLCollectionCell: UICollectionViewCell {
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  func setup() {
    self.layer.borderWidth  = 1.0
    self.layer.borderColor  = UIColor.red.cgColor
    self.layer.cornerRadius = 5.0
    self.backgroundColor    = UIColor.white
  }
  
}

class WLCollectionViewLayout: UICollectionViewFlowLayout {
  
  var previousOffset: CGFloat    = 0
  var currentPage: Int           = 0
  
  override func prepare() {
  }
  
  override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
    
    guard let collectionView = self.collectionView else {
      return CGPoint.zero
    }
    
    guard let itemsCount = collectionView.dataSource?.collectionView(collectionView, numberOfItemsInSection: 0) else {
      return CGPoint.zero
    }
    
    if ((previousOffset > collectionView.contentOffset.x) && (velocity.x < 0)) {
      currentPage = max(currentPage - 1, 0)
    } else if ((previousOffset < collectionView.contentOffset.x) && (velocity.x > 0.0)) {
      currentPage = min(currentPage + 1, itemsCount - 1);
    }
    
    let itemEdgeOffset:CGFloat = (collectionView.frame.width - itemSize.width -  minimumLineSpacing * 2) / 2
    let updatedOffset: CGFloat = (itemSize.width + minimumLineSpacing) * CGFloat(currentPage) - (itemEdgeOffset + minimumLineSpacing);
    
    previousOffset = updatedOffset;
    
    return CGPoint(x: updatedOffset, y: proposedContentOffset.y);
  }
}

class RootVC: UIViewController, UICollectionViewDataSource {
  
  var collectionView: UICollectionView?
  var collectionLayout: WLCollectionViewLayout = WLCollectionViewLayout()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
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
    
    let space: CGFloat                  = 30
    
    self.view                           = UIView(frame: UIScreen.main.bounds)
    self.view.backgroundColor           = UIColor.blue
    
    let collectionFrame                 = CGRect(x: 0, y: 60, width: view.frame.width, height: view.frame.height - 120)
    
    self.collectionView                 = UICollectionView(frame: collectionFrame, collectionViewLayout: collectionLayout)
    collectionView?.register(WLCollectionCell.self, forCellWithReuseIdentifier: "CELL")
    collectionView?.backgroundColor     = self.view.backgroundColor
    
    collectionView?.dataSource          = self
    collectionView?.isPagingEnabled     = false
    collectionView?.contentInset        = UIEdgeInsets(top: 0, left: space, bottom: 0, right: space)
    
    collectionLayout.scrollDirection    = .horizontal
    
    let itemWidth                       = view.frame.width - space * 4 // w0 == ws
    collectionLayout.itemSize           = CGSize(width: itemWidth, height: view.frame.height - 120 - 40)
    collectionLayout.minimumLineSpacing = space
    
    
    self.view.addSubview(self.collectionView!)
  }
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 4
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if let cell: WLCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CELL", for: indexPath) as? WLCollectionCell {
      
      return cell
    }
    
    return UICollectionViewCell()
  }
}
