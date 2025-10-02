module LammTools
#Copyright (c) 2021 Ryuichi Okamoto <ryubee@gmail.com>
#License: https://opensource.org/licenses/MIT

function ext_dump(file,datafile;Tstep=0)
    fn=open(file,"r")
    fn2=open(datafile,"r")
    fw=open("ex_$(Tstep).dump", "w")
    fw2=open("ex_$(Tstep).data","w")

    linedata=readline(fn2)
    s=split(linedata)
    s[end]="$(Tstep)"
    lamver=s[1]
    for i in 2:length(s)
        lamver=lamver*" "*s[i]
    end

    println(fw2,lamver) #header of the data file
    println(fw2,"")


    line=readline(fn)
    s=split(line)
    line2=readline(fn)
    step_init=parse(Int,line2)

    if step_init==Tstep
        println("timestep="*line2*" read!")

        println(fw,"ITEM: TIMESTEP")
        println(fw,Tstep)

        line=readline(fn)
        println(fw,line)
        line=readline(fn)
        println(fw,line)

        println(fw2, line*" atoms")

        for _ in 1:3
            linedata=readline(fn2)
        end


        s=split(linedata)
        Ntype=parse(Int,s[1])
    

        println(fw2,s[1]*" atom types")
        println(fw2,"")

        line=readline(fn)
        println(fw,line)
        line=readline(fn)
        println(fw,line)

        println(fw2, line*" xlo xhi")

        line=readline(fn)
        println(fw,line)

        println(fw2, line*" ylo yhi")

        line=readline(fn)
        println(fw,line)

        println(fw2, line*" zlo zhi")


        println(fw2,"")
        println(fw2,"Masses")

        println(fw2,"")

        for _ in 1:7
            linedata=readline(fn2)
        end

        for i in 1:Ntype
            linedata=readline(fn2)
            println(fw2,linedata)
        end


        println(fw2,"")

        println(fw2,"Atoms # charge")

        println(fw2,"")

        line=readline(fn)
        while line!="ITEM: TIMESTEP" && !eof(fn)
            println(fw,line)
            line=readline(fn)
            s=split(line)
            if length(s)==6 && s[1]!="ITEM:"
                println(fw2,line)
            end
        end
    else
    

        if line=="ITEM: TIMESTEP"
            println(fw,line)
            println(fw, line2)
        end

        

        line=readline(fn)
        while line!="ITEM: TIMESTEP"
            println(fw,line)
            line=readline(fn)
        end
        
    #    while !(line=="ITEM: TIMESTEP" && readline(fn)==Tstep)
    #        line=readline(fn)
    #    end
        
        line2=readline(fn)
        
        while line2!="$Tstep"
            line=readline(fn)
            while line!="ITEM: TIMESTEP"
                line=readline(fn)
            end
            line2=readline(fn)
            
        end

        println("timestep="*line2*" read!")

        println(fw,"ITEM: TIMESTEP")
        println(fw,Tstep)

        line=readline(fn)
        println(fw,line)
        line=readline(fn)
        println(fw,line)

        println(fw2, line*" atoms")

        for _ in 1:3
            linedata=readline(fn2)
        end


        s=split(linedata)
        Ntype=parse(Int,s[1])
        

        println(fw2,s[1]*" atom types")
        println(fw2,"")

        line=readline(fn)
        println(fw,line)
        line=readline(fn)
        println(fw,line)

        println(fw2, line*" xlo xhi")

        line=readline(fn)
        println(fw,line)

        println(fw2, line*" ylo yhi")

        line=readline(fn)
        println(fw,line)

        println(fw2, line*" zlo zhi")


        println(fw2,"")
        println(fw2,"Masses")

        println(fw2,"")

        for _ in 1:7
            linedata=readline(fn2)
        end

        for i in 1:Ntype
            linedata=readline(fn2)
            println(fw2,linedata)
        end


        println(fw2,"")

        println(fw2,"Atoms # charge")

        println(fw2,"")

        line=readline(fn)
        while line!="ITEM: TIMESTEP" && !eof(fn)
            println(fw,line)
            line=readline(fn)
            s=split(line)
            if length(s)==6 && s[1]!="ITEM:"
                println(fw2,line)
            end
        end    
    end

    close(fn)
    close(fn2)
    close(fw)
    close(fw2)
    
end


function ext_bonds(file;Tstep=0)
    fn=open(file,"r")

    line="initial"
 
    while line!="# Timestep $(Tstep) "
        line=readline(fn)    
    end

    println("line $(Tstep) read")

    for i in 1:2
        line=readline(fn)
    end
    
    fw2=open("bonds_$(Tstep).reaxc","w")

    println(fw2,"# Timestep $(Tstep)")
    println(fw2,"#")
    println(fw2,line)
    println(fw2,"#")
    println(fw2,"# Max number of bonds per atom 14 with coarse bond order cutoff 0.300")
    println(fw2, "# Particle connection table and bond orders")
    println(fw2, "# id type nb id_1...id_nb mol bo_1...bo_nb abo nlp q")
    
    line="initial"
 
    

    for i in 1:5
        line=readline(fn)
    end

    while !eof(fn) && line!="# "
        println(fw2,line)
        line=readline(fn)
    end
    println(fw2,line)

    close(fn)
    close(fw2)
    
end

function read_data_AtomsCharge(file)
    fn=open(file,"r")
    for _ in 1:3
        line=readline(fn)
    end
    s=split(line)
    Natom=parse(Int,s[1])

    line=readline(fn)
    s=split(line)
    atypes=parse(Int,s[1])

    readline(fn)

    box=Array{Float64}(undef,3,2)
    for i in 1:3
        line=readline(fn)
        s=split(line)
        box[i,1]=parse(Float64,s[1])
        box[i,2]=parse(Float64,s[2])
    end

    for _ in 1:(3+atypes+3)
        readline(fn)
    end

    types=Array{Int64}(undef,Natom)
    xyz=Array{Float64}(undef, Natom,3)
    charge=Array{Float64}(undef, Natom,3)

    for i in 1:Natom
        line=readline(fn)
        s=split(line)
        num=parse(Int,s[1])
        types[num]=parse(Int,s[2])
        xyz[num,1]=parse(Float64, s[4])
        xyz[num,2]=parse(Float64, s[5])
        xyz[num,3]=parse(Float64, s[6])
        charge[num]=parse(Float64, s[3])
    end
    Natom,atypes,box, types, charge, xyz
end


end
