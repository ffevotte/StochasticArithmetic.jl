using StochasticArithmetic
using StochasticArithmetic.EFT
using Test, Jive
using Formatting
using LinearAlgebra
using Random

Random.seed!(42)

@onlyonce begin
    const x1 = [-6.340663515282668472e-01, -1.032478304663339008e+00, -9.398547076618038787e+00, 8.775666080119043144e+00,
                8.154021046137667206e-01, -2.872197835897075890e+00, -4.130201373187722957e+00, -3.800523733887637978e-01,
                3.767316625622183501e+00, -7.693130974005489620e+00, 3.789995392417770503e+00, 2.332943819408263633e-02,
                1.117290458364406547e+00, -1.029424506285847585e+01, -1.972399240364107298e+00, 2.409324890261351548e+00,
                1.514218404563302478e+01, -9.803395024842704863e-01, 3.624014860482689393e+00, 3.454279166512129517e+00,
                2.150407406181448877e+00, 8.380973701960218181e-01, -4.718497388831256245e+00, 1.092357091710888817e+01,
                6.201621778907238092e-01, -2.431850975835210704e+00, -9.587862761576261272e-01, -4.744452383420612485e+00,
                -1.928632137138599045e+00, -1.514994713586201414e+00, -2.183297984924969626e+00, 1.424576004184546996e+01,
                9.692913616904123231e+00, -1.547104695550167275e+00, 4.204554274223821331e+00, 9.347482098474469980e-01,
                7.399023959120087923e-02, -4.191315817777256925e+00, 8.475563783170365184e+00, -1.721899852461975300e+00,
                -7.486679611973100279e+00, -5.787527477378286850e-02, 5.560569808434617123e+00, 9.797972685704890716e-02,
                -1.002061593959254537e+00, -3.012224958934606622e+00, -8.084325856937959465e-01,-1.905132695346669347e-01,
                5.188198608642882181e-01, -7.601644981994752914e-01, -2.451000778662956403e+00, -9.693293689094003573e-01,
                2.882117571206391560e+00, 2.269843085532857518e+00, 2.958122951288597147e+00, 2.630063037097047030e+00,
                -6.039968388496026463e+00, -4.780642850877452332e+00, 2.900723065170244808e-01, -1.902925253860966448e+00,
                -1.317310182590558298e+01, 3.598067326176326297e-01, 9.089778308264061524e-01, -3.252711812214260867e+00,
                -2.310740125115115173e+00, -1.617256866537321480e+00, 2.935716535944118633e+00, -3.234285498797106584e+00,
                3.237522392256278359e+00, 4.234360820593143337e+00, -8.323039886529393083e-02, 3.392892532427555174e+00,
                4.675163615855799232e-02, -2.586710584045738504e+00, 7.263314423520003116e-01, -1.805428377059409950e+00,
                5.540332712174778074e-01, -1.680124146046180877e+00, 3.384520587773187650e-01, -9.285586956857446950e+00,
                1.226698449940088764e+01, 1.955258288381735765e+00, -1.751307418060096488e+00, 2.822752021460029237e+00,
                3.284769252355420832e+00, -1.435237503511320289e+00, -1.640731710755447281e+01, -5.073426138128573903e+00,
                2.769683815669464200e-01, -2.364893385542928161e+00, -2.852226279751059579e+00, 9.442997895825611110e-02,
                1.613660165004466629e+00, -7.535249859542684225e-01, 1.875042460291437951e+00, -1.204955334660282817e+00,
                -1.312339352451679320e+00, 1.029598837959142621e+01, 1.181600593671352062e+00, -1.298538943700622506e+00]

    const y1 = [2.904271758197305431e+00, -7.586923460587383872e+00, -2.433948194217723793e-01, 7.211094113495739588e-01,
                3.682896270200847866e+00, -1.300501673307355999e+00, -1.156385074689293901e+01, 3.527526896240007925e+00,
                6.138604794505512219e-01, 3.789599979884540115e+00, 4.964840840608681027e+00, 1.003350838878128926e+00,
                4.318670472060466281e+00, 1.014498387743745011e+00, -2.234343190283604841e+00, -6.082736396317145466e-01,
                2.676279050222233336e-01, -2.474834547943665974e+00, -1.502899068454430775e+00, -1.853840253722779163e+00,
                -2.690201016281298152e+00, -2.762974865876188346e+00, -1.691254623016295255e+00, 7.037535285788961217e-03,
                8.664535245217100945e-01, -1.152357491478533280e+00, 1.028831455069202150e+00, -1.999749826926913443e-01,
                -4.083433509619152524e+00, 8.094079296833567305e-01, 1.548542269669347382e+00, 1.980881016229119940e+00,
                8.859099623710096072e-01, 1.071154721221595274e+01, -9.323551904078861141e-02, 1.071342262133416101e+00,
                -4.657941295025913031e-01, -1.417360280450415067e+00, 2.973792467793110017e+00, -5.333088668455037151e-01,
                3.506402422142353981e+00, -2.626404402475698419e+01, -5.821956212486361082e+00, -2.081525484012217042e+00,
                1.166141951259942111e+01, -2.097572645415919368e-01, -4.170975773332724401e+00, -1.088414007670470252e+00,
                1.437306693315153927e+00, 2.525907646776998305e+00, -3.752587514423713078e+00, 1.547393157729613611e+00,
                5.679913072629369508e-02, -4.458331660254577500e+00, -1.152536727954037943e+00, 6.959027574408890082e+00,
                -4.529530640152803933e+00, 2.850439979915360689e-01, 1.551842054260149303e-02, -2.499408640456699970e+00,
                8.025705275120998294e+00, -2.339259319371728374e+00, 1.690685407197963785e-01, 1.773766221659853759e+00,
                8.418125128249426270e-02, -1.240164986459572516e+00, 1.244333273760872993e+00, 2.229039874696919110e+00,
                1.578366388587486036e+01, 4.010353714690342741e+00, 4.066297377969993221e+01, -3.590142776920160483e-01,
                -5.317967102854119776e-01, -5.773767334043824473e-01, -1.684750638812332113e+00, 3.036554271013544026e-01,
                -1.915078321632401881e+00, 1.230841242088420717e+00, -1.360733255768588945e+00, -2.194897100045668736e+00,
                -3.147503241618139214e-01, -6.491785562479393867e+00, 8.732579404206023410e-01, -1.197064788553268588e+00,
                -1.051560432555771030e+00, 3.857770155380043642e-01, 1.780083978520605070e+00, 6.985067850240034293e-01,
                5.260718423653707454e+00, 2.393421981789398967e-01, 1.226572487102020936e+00, -4.390511466037616550e-01,
                4.857518183853492544e-01, 9.529898633767956539e+00, 1.640668058073694624e+01, 1.437731392011400100e+00,
                2.081762488795357413e+00, -1.677143583187016507e+00, 3.714458425965566635e-01, -1.788480931953309927e+00]

const x2 = [-4.703899089072115913e+01, -2.302208194432241726e+03, -1.564726108041984262e+05, 1.526300899208613373e+04,
            -2.132307857407913616e+02, 2.307518097958435537e+05, -5.192572714570803782e+01, 2.325599833211251966e+00,
            2.817494622670464651e+03, 1.708710020563955254e+02, 6.269522630918198303e+01, 3.687443650750188340e+01,
            1.038604765677104957e+01, -1.915975573744401117e+03, 1.168276776869518835e+04, 2.454491144842770009e+05,
            -5.592615927834867051e+01, 1.850307202352605032e+02, -3.838926631532003521e+05, 4.581024635636574203e+03,
            -4.418458866400893044e+02, -1.291545011255889767e+04, -2.048725390018565307e+01, 1.204863349219630436e+03,
            9.760401372457109259e-01, 1.410078033770042748e+04, -4.813837462145154859e+04, -1.437299278084431897e+01,
            -5.155141433885022707e+03, -2.255002085683215992e+05, 5.356346283817102085e+04, 3.667837584637414693e+04,
            -7.216672700119137880e+04, -1.259108454694217698e+03, 4.419830333598044092e+01, -3.585915213658949360e+05,
            3.816928321706653549e+01, 2.135141050205000557e+00, 1.174394551478064532e+05, -2.710374703222661275e+00,
            1.611291396027762385e+05, -1.357925813584457501e+03, -1.242968716437326115e+01, 7.973254168167831267e+03,
            -1.866706364323428602e+02, 2.042441529597737571e+01, 2.158858184523954282e+00, 2.467055660032614028e+01,
            5.375520883445242362e+04, -1.144212376192913938e+00, 5.994613017286798140e+02, 3.193496564759223055e+00,
            -4.148337081370820911e-01, -4.005110071830330076e-01, 1.993341984143252921e+04, -1.147244379776030421e+01,
            6.119929339861500672e-01, -6.092377012266528027e+02, 2.411059939457267774e+03, 9.559736934852315926e+01,
            -4.805764149222165997e+02, 4.009221133304038085e+04, 8.398867979989321775e-02, 5.743855858417433069e+01,
            -4.980311032420013362e+02, 1.509343053835127830e+04, 1.454679269769394365e-02, 2.854821043634199995e+01,
            -4.072883091111050291e-01, 5.108044955045782842e+01, -4.071539984133301004e+03, 8.751867981322608614e+01,
            -1.285130410507232591e+05, -3.354125317288757287e+03, 8.135505746482945000e-01, 4.723687613018444154e+01,
            1.189127895476845197e+03, -2.595180439442086026e+03, -3.753511234127828402e+02, 6.828869753373305151e+00,
            -2.424235269921588838e+02, -1.527378814146540753e+00, -2.753704293718250701e+05, 6.474506937411601548e+00,
            -1.077862672807065770e+06, -4.139018884967313352e+04, -1.418115653149918671e+03,-1.042964882907427171e+00,
            1.508774032010480548e+00, -1.001265318103480295e+00, 2.624649797909716753e+00, -1.368302828037557447e+04,
            -6.551342612757771349e+02, -1.855860091170598389e+04, 3.231487400789144715e+01, 9.365283668012376438e+03,
            1.078202387444531450e+04, 1.383253991429271628e+04, 1.406923835053669469e+00, -5.288835748811105963e-01]

const y2 = [-1.252871778887357568e+00, 1.078962521009007787e+03, -3.174894745849149331e+04, -1.530373455916264093e-02,
            4.784478272815556821e+00, -1.192086818719253206e+05, 3.668476944821762942e+01, 1.952404524146996501e+00,
            4.765260911366479377e+03, -3.289741608770166970e-01, -4.226193799391714911e+00, -1.824747767003190901e+01,
            1.352880351874526710e+00, 2.528843202632653629e+03, -1.591117252770609957e+04, -7.948333831513273440e-01,
            1.763730594001834406e+00, -4.142264664747529190e-01, 1.066477328704419342e+05, 3.159332045246057532e+03,
            -1.553414963997087783e+00, 6.473297499671324395e-01, -5.969956700965419749e+00, -1.432466768506058770e+03,
            3.846365749072568452e+00, 2.790519287535665249e+00, 2.712376392123455826e+00, 3.495804741318556119e-01,
            -1.976446781200929399e+04, 1.520383644699746801e+05, 2.197669377729083135e+04, -1.069924380149832541e+04,
            -1.364616481795411164e+04, 2.396787353506200924e-01, 1.576007089234049907e+01, -1.640112041994733736e+06,
            5.423184829884636571e+00, -2.854528605476235548e+00, 1.147783795765330961e+00, -1.108619081995681377e+00,
            -1.290633352716010995e+05, 8.452162075538846020e-01, -1.339879936618119416e+02, -1.094006209459130559e+03,
            2.012798587947189688e+00, -9.383522798994409220e-01, -1.090080505163032232e+00, 2.617736898339717300e+01,
            1.163689330823294954e+00, -1.997489359474004189e+01, -1.497673101858773350e+02, 2.910347668348660832e+01,
            6.358777943232427621e-01, -3.223860439180939785e+00, -1.020470547974752958e-02, -2.573297990895500220e+01,
            1.219805387956967024e+00, 8.361151282404189260e+02, 3.744876783652914298e+01, -2.384432846910274861e+01,
            4.299066016316168692e+00, -3.581774420101832220e+04, 6.850586911579179095e+00, 1.991718463645072712e-01,
            -7.417107650666663403e+02, -7.336543124226103828e+03, -5.102552005287688264e-01, 4.026602472160422508e+01,
            3.045402731323658330e+01, 6.217979244611119327e+01, 4.537584779899785644e+03, -6.591459843464705592e+00,
            3.949078543721616708e+00, -1.752538562659680388e-01, 5.175050101609877107e-01, 9.134566870551368822e+01,
            2.127631922755461868e+00, -3.851289922958672785e-01, -5.430969234878427443e+01, 2.599543161451561613e+00,
            2.418636072495988856e+02, 2.920924458066446405e+00, -3.498182839331332798e+04, 1.412711102346127312e+01,
            4.450907201869644923e+05, -4.828728797199047129e+00, 4.874121684200859050e+01, 6.351064829043707505e+00,
            -1.052720771587801307e+00, 4.862959846339910541e+01, -5.724214959936722025e-01, 1.159505461894495326e+00,
            1.220304567286626707e+02, -8.614815388556389397e-01, -2.020054259416569076e-01, 7.288236435882137130e+02,
            -4.939913027080400365e-01, 2.953432423721218220e+04, -5.565878606086428704e+00, 6.137681992750880777e-01]
end

@testset "StochasticArithmetic" begin
    @testset "EFT" begin

        @testset "twoSum" begin
            let (x,y) = twoSum(0.1, 0.3)
                @test x ≈  0.4
                @test y ≈ -2.7755575615628914e-17
            end

            let (x,y) = twoSum(0.1f0, 0.2f0)
                @test x ≈  0.3f0
                @test y ≈ -7.450581f-9
            end
        end

        @testset "twoProd" begin
            let (x, y) = twoProd(0.1, 5.)
                @test x ≈ 0.5
                @test y ≈ 2.7755575615628914e-17
            end

            let (x, y) = twoProd(0.1f0, 5.f0)
                @test x ≈ 0.5f0
                @test y ≈ 7.450581f-9
            end
        end

        @testset "twoDiv" begin
            let (x, y) = twoDiv(1., 3.)
                @test x ≈ 0.3333333333333333
                @test y ≈ 1.850371707708594e-17
            end

            let (x, y) = twoDiv(1.f0, 3.f0)
                @test x ≈  0.333333f0
                @test y ≈ -9.934108f-9
            end
        end

        @testset "split" begin
            function checkSplit(a)
                binRepr(x) = format("{:b}", Int(significand(x)*2^(53)))
                (x, y) = split(a)

                xTrim = replace(binRepr(x), r"0+$" => "")
                @test startswith(binRepr(a), xTrim)

                n = length(xTrim)
                aEnd = (binRepr(a))[n+1:end]
                aEnd = replace(aEnd, r"^0+" => "")
                aEnd = replace(aEnd, r"0+$" => "")
                yTrim = replace(binRepr(y), r"0+$" => "")
                @test aEnd == yTrim
            end

            checkSplit(0.1)
        end
    end

    @testset "rounding modes" begin
        @testset "directed" begin
            for (x,y) in [(0.1, 0.3), (-0.31, 0.0125)]
                @test +(DWN, x, y) < +(UP, x, y)
                @test *(DWN, x, y) < *(UP, x, y)
                @test /(DWN, x, y) < /(UP, x, y)
            end
        end

        @testset "random" begin
            for (x,y) in [(0.1, 0.3), (-0.31, 0.0125)]
                @test all(+(RND, x, y) in (+(UP, x, y), +(DWN, x, y)) for _ in 1:100)
                @test all(*(RND, x, y) in (*(UP, x, y), *(DWN, x, y)) for _ in 1:100)
                @test all(/(RND, x, y) in (/(UP, x, y), /(DWN, x, y)) for _ in 1:100)
            end
        end
    end

    for T in (SFloat64, SFloat32)
        @testset "$T" begin
            @testset "4 ops" begin
                let x = T(0.1) + T(0.3)
                    @test x isa T
                    @test value(x) ≈ 0.4
                end

                let x = T(0.1) - T(0.3)
                    @test x isa T
                    @test value(x) ≈ -0.2
                end

                let x = T(0.1) * T(0.3)
                    @test x isa T
                    @test value(x) ≈ 0.03
                end

                let x = T(0.1) / T(0.3)
                    @test x isa T
                    @test value(x) ≈ 0.1/0.3
                end
            end

            @testset "abs" begin
                let x = -0.1;  @test value(abs(T(x))) ≈ -x end
                let x =  0.1;  @test value(abs(T(x))) ≈  x end
            end

            @testset "isless" begin
                @test T(1) < 2.
                @test 1    < T(2)
                @test T(1) < T(2)
            end

            @testset "linsolve" begin
                let
                    tol(SFloat64) = 1e-15
                    tol(SFloat32) = 1e-6

                    A = Float64[1 2 3;
                                4 5 6;
                                7 8 10]
                    B = Float64[1 ; 2 ; 3]
                    Xref = A \ B

                    function check(Xsto)
                        value(Xsto[1]) ≈ Xref[1]     || return false
                        value(Xsto[2]) ≈ Xref[2]     || return false
                        abs(value(Xsto[3])) < tol(T) || return false
                        true
                    end
                    @test all(check(T.(A) \ T.(B)) for _ in 1:10)
                end
            end
        end
    end

    @testset "mixed" begin
        let
            x32 = SFloat32(32)
            x64 = SFloat64(64)

            x = x32 + x64
            @test x isa SFloat64
            @test value(x) ≈ 96

            x = x64 + x32
            @test x isa SFloat64
            @test value(x) ≈ 96

            x = x64 + 2.0
            @test x isa SFloat64
            @test value(x) ≈ 66

            x = 2.0 + x64
            @test x isa SFloat64
            @test value(x) ≈ 66

            @test SFloat64(1) < SFloat32(2)
            @test SFloat32(1) < SFloat64(2)
        end
    end

    @testset "reliable_digits" begin
        let
            mu, s = (@reliable_digits dot(SFloat64.(x1), SFloat64.(y1)))
            @test mu ≈ dot(x1, y1)
            @test s  ≈ 13.37        atol = 0.01
        end

        let
            mu, s = (@reliable_digits dot(SFloat32.(x1), SFloat32.(y1)))
            @test mu ≈ dot(Float32.(x1), Float32.(y1))
            @test s  ≈ 4.87         atol = 0.01
        end

        let
            mu, s = (@reliable_digits dot(SFloat64.(x2), SFloat64.(y2)))
            @test mu ≈ dot(x2, y2)  atol = 0.01
            @test s  ≈ 3.53         atol = 0.01
        end

        let
            mu, s = (@reliable_digits dot(SFloat32.(x2), SFloat32.(y2)))
            @test s  ≈ -0.25        atol = 0.01
        end
    end
end
