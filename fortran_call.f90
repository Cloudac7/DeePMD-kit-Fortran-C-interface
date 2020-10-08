program fortran_call
    use deepmd_wrapper
    implicit none
    type(nnp) :: pot
    integer :: vecsize
    integer,target,allocatable :: atype(:)
    real(8), target,allocatable :: coord(:)
    real(8), target, allocatable  :: box(:)
    real(8), target, allocatable :: fparam(:)
    real(8), target, allocatable :: aparam(:)
    real(8), target :: force(190*3), virial(9), atom_ener(190), atom_virial(190*9)
    real(8), target :: ener
    real(8), dimension(:), pointer :: dforce, dvirial, datom_ener, datom_virial, dcoord, dbox, dfparam, daparam
    real(8), pointer :: dener
    integer, dimension(:), pointer :: datype
    allocate(box(9))
    allocate(atype(190))
    allocate(coord(190*3))
! input the test data
     vecsize=190
     ener=0.0
     force=0.0
     virial=0.0
     atom_ener=0.0
     atom_virial=0.0
    fparam=0.0
    aparam=0.0
    box = (/12.42, 0.0, 0.0, 0.0, 12.42, 0.0, 0.0, 0.0, 12.42/)
    atype = (/&
            0,1,1,0,1,1,0,1,1,0,&
            1,1,0,1,1,0,1,1,0,1,&
            1,0,1,1,0,1,1,0,1,1,&
            0,1,1,0,1,1,0,1,1,0,&
            1,1,0,1,1,0,1,1,0,1,&
            1,0,1,1,0,1,1,0,1,1,&
            0,1,1,0,1,1,0,1,1,0,&
            1,1,0,1,1,0,1,1,0,1,&
            1,0,1,1,0,1,1,0,1,1,&
            0,1,1,0,1,1,0,1,1,0,&
            1,1,0,1,1,0,1,1,0,1,&
            1,0,1,1,0,1,1,0,1,1,&
            0,1,1,0,1,1,0,1,1,0,&
            1,1,0,1,1,0,1,1,0,1,&
            1,0,1,1,0,1,1,0,1,1,&
            0,1,1,0,1,1,0,1,1,0,&
            1,1,0,1,1,0,1,1,0,1,&
            1,0,1,1,0,1,1,0,1,1,&
            0,1,1,0,1,1,0,1,1,2/)
    coord = (/& 
  3.32633000 ,      2.16018000 ,      8.72841000  ,& 
  3.78076000 ,      1.31616000 ,      8.57063000  ,& 
  3.61280000 ,      2.57463000 ,      9.62354000  ,& 
  8.57382000 ,      0.83530600 ,      8.13533000  ,& 
  7.98689000 ,      1.44746000 ,      7.59597000  ,& 
  9.36347000 ,      1.40472000 ,      8.41035000  ,& 
 11.43690000 ,      9.90021000 ,     12.57200000  ,& 
 10.67230000 ,     10.13920000 ,     11.95400000  ,& 
 12.00290000 ,     10.71790000 ,     12.59470000  ,& 
  4.53083000 ,     12.16200000 ,      8.09655000  ,& 
  5.29205000 ,     11.70750000 ,      8.60428000  ,& 
  3.90787000 ,     11.47830000 ,      7.71210000  ,& 
  7.40450000 ,      8.75039000 ,      5.50498000  ,& 
  6.68692000 ,      8.30920000 ,      5.05590000  ,& 
  7.30487000 ,      9.68061000 ,      5.82067000  ,& 
 10.11940000 ,      1.25342000 ,     11.62670000  ,& 
 10.19370000 ,      1.32707000 ,     12.63880000  ,& 
  9.14929000 ,      1.00263000 ,     11.29320000  ,& 
  8.88591000 ,      5.02708000 ,     11.37000000  ,& 
  8.72304000 ,      6.00989000 ,     11.36940000  ,& 
  8.09963000 ,      4.65269000 ,     11.86740000  ,& 
  9.93555000 ,      4.84404000 ,      7.85283000  ,& 
  9.00557000 ,      4.86705000 ,      8.20788000  ,& 
 10.45190000 ,      5.60803000 ,      8.22641000  ,& 
 12.17370000 ,      7.28653000 ,     12.01870000  ,& 
 12.11580000 ,      8.18615000 ,     12.36740000  ,& 
 12.39300000 ,      6.74737000 ,     12.79040000  ,& 
  1.02669000 ,      2.90061000 ,      7.18910000  ,& 
  0.99733600 ,      3.83272000 ,      7.56065000  ,& 
  1.69619000 ,      2.45088000 ,      7.77879000  ,& 
  3.82769000 ,      7.63869000 ,      6.46730000  ,& 
  4.22817000 ,      7.54152000 ,      5.55784000  ,& 
  3.55916000 ,      8.58268000 ,      6.57959000  ,& 
  8.99369000 ,      6.05993000 ,      5.63238000  ,& 
  9.16784000 ,      5.58969000 ,      6.47553000  ,& 
  8.53356000 ,      6.88237000 ,      5.86767000  ,& 
  4.70183000 ,      1.45744000 ,     11.12550000  ,& 
  4.66625000 ,      0.52764900 ,     10.91030000  ,& 
  4.05524000 ,      1.59744000 ,     11.89700000  ,& 
 10.22660000 ,      1.02437000 ,      1.92815000  ,& 
 10.16660000 ,      0.04621150 ,      2.17466000  ,& 
 11.05380000 ,      1.41171000 ,      2.35476000  ,& 
  9.45433000 ,      7.95019000 ,     10.93570000  ,& 
  9.22506000 ,      7.79581000 ,     10.01540000  ,& 
 10.34700000 ,      7.46896000 ,     11.08650000  ,& 
  1.78254000 ,     10.96600000 ,      4.54880000  ,& 
  2.17627000 ,     10.13420000 ,      4.12773000  ,& 
  0.76659300 ,     10.92150000 ,      4.62528000  ,& 
  9.40453000 ,     10.67810000 ,      7.51876000  ,& 
  9.03332000 ,     11.57590000 ,      7.44313000  ,& 
  9.86059000 ,     10.63180000 ,      6.63953000  ,& 
  9.73002000 ,      9.09719000 ,      4.01537000  ,& 
  8.84035000 ,      8.82518000 ,      4.41181000  ,& 
  9.49935000 ,      9.69175000 ,      3.28022000  ,& 
  4.56016000 ,      4.96835000 ,      4.84758000  ,& 
  4.86746000 ,      4.50251000 ,      4.06752000  ,& 
  3.60324000 ,      4.89705000 ,      4.90566000  ,& 
 10.89810000 ,      3.26646000 ,      5.18903000  ,& 
  9.98105000 ,      3.50556000 ,      4.97357000  ,& 
 10.83980000 ,      2.74825000 ,      5.95069000  ,& 
 12.40190000 ,      4.98874000 ,      1.35815000  ,& 
 11.77210000 ,      5.67566000 ,      1.72903000  ,& 
 12.41140000 ,      4.13670000 ,      1.99769000  ,& 
  6.70524000 ,      2.94596000 ,      0.29300600  ,& 
  6.94887000 ,      2.32014000 ,      1.08293000  ,& 
  5.96570000 ,      2.51964000 ,     12.25330000  ,& 
  7.55277000 ,      4.43402000 ,      9.08876000  ,& 
  7.99112000 ,      4.50397000 ,      9.96120000  ,& 
  6.75582000 ,      4.84827000 ,      9.32720000  ,& 
  5.03420000 ,      7.33877000 ,      3.84656000  ,& 
  4.19630000 ,      7.76289000 ,      3.36853000  ,& 
  4.79751000 ,      6.43812000 ,      4.05705000  ,& 
  0.89637000 ,      9.18310000 ,      8.41364000  ,& 
  0.05084270 ,      9.50265000 ,      8.70208000  ,& 
  1.18393000 ,      8.57627000 ,      9.18471000  ,& 
  2.84537000 ,     11.88790000 ,      1.87043000  ,& 
  2.47195000 ,     11.87330000 ,      2.81845000  ,& 
  3.86784000 ,     11.86250000 ,      2.03460000  ,& 
 11.54250000 ,      4.37726000 ,     11.37540000  ,& 
 10.66610000 ,      4.81714000 ,     11.41670000  ,& 
 12.02740000 ,      4.56499000 ,     12.19960000  ,& 
 10.94550000 ,      2.42473000 ,      8.69021000  ,& 
 10.63620000 ,      3.37817000 ,      8.51399000  ,& 
 11.70840000 ,      2.40141000 ,      8.10480000  ,& 
  9.60306000 ,     10.77050000 ,      1.99269000  ,& 
  8.83349000 ,     10.72320000 ,      1.34581000  ,& 
 10.38190000 ,     10.40070000 ,      1.50999000  ,& 
 11.84750000 ,      6.21743000 ,      9.24779000  ,& 
 11.72850000 ,      5.45408000 ,      9.87652000  ,& 
  0.18872100 ,      6.16466000 ,      8.57983000  ,& 
 -0.07122820 ,      2.79139000 ,      2.93818000  ,& 
 12.07300000 ,      2.82538000 ,      3.85781000  ,& 
  0.81293300 ,      2.48082000 ,      3.10098000  ,& 
  7.36085000 ,     11.46020000 ,      5.72243000  ,& 
  6.85480000 ,     12.12330000 ,      6.21320000  ,& 
  7.59597000 ,     12.09460000 ,      4.95557000  ,& 
 10.13310000 ,      6.67610000 ,      2.36977000  ,& 
 10.05100000 ,      7.04024000 ,      1.45951000  ,& 
  9.86885000 ,      7.40173000 ,      2.93140000  ,& 
 11.29310000 ,     11.59560000 ,     10.03160000  ,& 
 10.86970000 ,     12.35410000 ,     10.48890000  ,& 
 10.68410000 ,     11.25320000 ,      9.30311000  ,& 
  8.32693000 ,      3.73205000 ,      4.48568000  ,& 
  7.79800000 ,      3.50191000 ,      5.28791000  ,& 
  8.33441000 ,      4.73996000 ,      4.61696000  ,& 
  2.59591000 ,      2.28376000 ,      0.62084700  ,& 
  2.06429000 ,      1.94501000 ,     -0.17085500  ,& 
  2.47989000 ,      1.55066000 ,      1.25686000  ,& 
  8.61168000 ,      7.78163000 ,      8.08982000  ,& 
  8.86320000 ,      8.73320000 ,      8.06049000  ,& 
  7.65574000 ,      7.88095000 ,      7.90407000  ,& 
 11.96380000 ,      5.82933000 ,      4.98397000  ,& 
 11.61240000 ,      5.00175000 ,      5.39842000  ,& 
 11.18350000 ,      6.46993000 ,      5.01285000  ,& 
  7.60808000 ,      0.46056700 ,     11.13980000  ,& 
  7.12536000 ,      1.23670000 ,     11.32370000  ,& 
  7.47580000 ,      0.21791500 ,     10.25110000  ,& 
  1.95189000 ,      7.74935000 ,     10.31570000  ,& 
  2.61335000 ,      8.39034000 ,     10.60780000  ,& 
  1.19437000 ,      7.60990000 ,     10.92850000  ,& 
  7.13208000 ,      7.98972000 ,     12.63280000  ,& 
  7.86807000 ,      7.98721000 ,     11.99450000  ,& 
  7.12348000 ,      7.51031000 ,      1.05763000  ,& 
  4.87653000 ,      1.06936000 ,      5.52226000  ,& 
  4.65449000 ,      0.35064700 ,      6.08662000  ,& 
  5.29408000 ,      0.55502000 ,      4.75826000  ,& 
  5.51465000 ,     12.11520000 ,      2.85585000  ,& 
  6.08949000 ,      0.47603100 ,      2.82304000  ,& 
  5.95358000 ,     11.38470000 ,      2.35343000  ,& 
  1.51736000 ,     11.58260000 ,     11.99790000  ,& 
  2.14167000 ,     11.64830000 ,      0.32514900  ,& 
  1.61163000 ,     10.64590000 ,     11.65640000  ,& 
  4.87764000 ,      4.16986000 ,      7.55479000  ,& 
  4.13230000 ,      3.49357000 ,      7.74711000  ,& 
  4.74458000 ,      4.44462000 ,      6.62400000  ,& 
  7.08115000 ,      6.46042000 ,      2.11404000  ,& 
  6.23476000 ,      6.69312000 ,      2.61123000  ,& 
  7.58072000 ,      5.84717000 ,      2.62140000  ,& 
 11.76040000 ,     10.19860000 ,      5.29413000  ,& 
 12.19190000 ,      9.39287000 ,      5.69436000  ,& 
 11.06130000 ,      9.81673000 ,      4.72420000  ,& 
  7.56822000 ,      1.59571000 ,      2.74781000  ,& 
  8.37183000 ,      1.30995000 ,      2.32992000  ,& 
  7.77903000 ,      2.36666000 ,      3.32661000  ,& 
  3.47260000 ,      5.52235000 ,      9.85853000  ,& 
  3.85782000 ,      5.33794000 ,      9.00725000  ,& 
  2.92076000 ,      6.34681000 ,      9.79067000  ,& 
  4.60588000 ,      4.09833000 ,      2.01286000  ,& 
  5.43736000 ,      3.83113000 ,      1.50369000  ,& 
  3.93287000 ,      3.41661000 ,      1.71791000  ,& 
  6.01808000 ,      6.14494000 ,     10.95410000  ,& 
  6.23220000 ,      6.92214000 ,     11.57800000  ,& 
  5.05712000 ,      6.10278000 ,     10.70530000  ,& 
  7.16829000 ,     10.61840000 ,      0.64677300  ,& 
  7.14856000 ,      9.69339000 ,      0.34405500  ,& 
  7.39695000 ,     11.17660000 ,     12.26670000  ,& 
  6.00163000 ,      7.93869000 ,      8.31762000  ,& 
  5.84542000 ,      7.12903000 ,      8.78072000  ,& 
  5.26107000 ,      7.89836000 ,      7.64714000  ,& 
  3.88255000 ,      8.59647000 ,     12.11360000  ,& 
  4.88840000 ,      8.63432000 ,     12.16230000  ,& 
  3.70712000 ,      7.70947000 ,     -0.07205820  ,& 
  2.36320000 ,      2.64809000 ,      4.33802000  ,& 
  2.92993000 ,      1.90880000 ,      4.60194000  ,& 
  1.78894000 ,      2.85324000 ,      5.14537000  ,& 
  0.90420200 ,      1.46770000 ,     10.58110000  ,& 
  1.63919000 ,      1.72710000 ,      9.97378000  ,& 
  1.02074000 ,      0.53153100 ,     10.72140000  ,& 
  1.77004000 ,      6.19816000 ,      3.29864000  ,& 
  0.94212500 ,      6.13113000 ,      3.79247000  ,& 
  1.91658000 ,      5.58438000 ,      2.54269000  ,& 
  2.83442000 ,      8.60909000 ,      2.97686000  ,& 
  2.36971000 ,      7.70808000 ,      3.07315000  ,& 
  3.07270000 ,      8.76612000 ,      2.02104000  ,& 
  6.78741000 ,     10.61150000 ,      9.33399000  ,& 
  7.60658000 ,     10.42690000 ,      8.76662000  ,& 
  6.22344000 ,      9.81382000 ,      9.23007000  ,& 
  6.96209000 ,      2.56056000 ,      6.76499000  ,& 
  6.12800000 ,      2.13816000 ,      6.40522000  ,& 
  6.56818000 ,      3.21998000 ,      7.46566000  ,& 
  1.32358000 ,      5.80021000 ,      7.21374000  ,& 
  1.13841000 ,      5.94414000 ,      6.33224000  ,& 
  2.07066000 ,      6.37951000 ,      7.40354000  ,& 
  3.15462000 ,      6.27215000 ,      0.77453000  ,& 
  2.63337000 ,      5.86943000 ,     12.43070000  ,& 
  3.77947000 ,      5.54689000 ,      0.94629400  ,& 
  2.78089000 ,     10.27510000 ,      6.92862000  ,& 
  1.98584000 ,      9.88519000 ,      7.38579000  ,& 
  2.48104000 ,     10.60930000 ,      6.01716000  ,& 
  11.56800000,       2.38200000,      10.69430000 /)

      dener => ener
      dforce => force
      dvirial => virial
      datom_ener => atom_ener
      datom_virial => atom_virial
      dcoord => coord
      datype => atype
      dbox => box
      dfparam => fparam
      daparam => aparam
      pot=create_nnp('graph.pb')
     call compute_nnp(pot%ptr, vecsize, dener, dforce, dvirial, datom_ener, datom_virial, dcoord, datype, dbox, dfparam, daparam)
      print*, dener
      print*, dforce
      print*, datom_ener
end program fortran_call
