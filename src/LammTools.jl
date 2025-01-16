module LammTools
#Copyright (c) 2021 Ryuichi Okamoto <ryubee@gmail.com>
#License: https://opensource.org/licenses/MIT

function ext_dump(file,datafile;Tstep=2000000)
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



    line=readline(fn)
    s=split(line)
    line2=readline(fn)
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
        println("timestep="*line2)
    end

    println(fw,"ITEM: TIMESTEP")
    println(fw,Tstep)


    for _ in 1:3
        linedata=readline(fn2)
    end

    

    s=split(linedata)
    Ntype=parse(Int,s[1])
    #mass=Array{String}(undef,Ntype)
    

    
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

    #= println(fw2,"1 12")
    println(fw2,"2 1.008")
    println(fw2,"3 1.008")
    println(fw2,"4 16")
    println(fw2,"5 16")
    println(fw2,"6 88.90519999999999")
    println(fw2,"7 91.224")
    println(fw2,"8 1.008")
    println(fw2,"9 16")
    println(fw2,"10 12")
    println(fw2,"11 1.008")
    println(fw2,"12 16")
    println(fw2,"13 1.008") =#

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


    close(fn)
    close(fw)
    close(fw2)
    
end


function ext_bonds(file;Tstep=30000,N=5717)
    fn=open(file,"r")
    
    fw2=open("bonds_$(Tstep).reaxc","w")

    println(fw2,"# Timestep $(Tstep)")
    println(fw2,"#")
    println(fw2,"# Number of particles $(N)")
    println(fw2,"#")
    println(fw2,"# Max number of bonds per atom 14 with coarse bond order cutoff 0.300")
    println(fw2, "# Particle connection table and bond orders")
    println(fw2, "# id type nb id_1...id_nb mol bo_1...bo_nb abo nlp q")
    
    line="initial"
 
    while line!="# Timestep $(Tstep) "
        line=readline(fn)    
    end
    println("line $(Tstep) read")

    for i in 1:7
        line=readline(fn)
    end

    while !eof(fn) && line!="# "
        println(fw2,line)
        line=readline(fn)
    end


    close(fn)
    close(fw2)
    
end

end
