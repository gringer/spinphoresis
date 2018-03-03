#!/usr/bin/Rscript

epl <- list(c(0,0),c(0,0),c(0,0),c(0,0));
apl <- list(c(0,0),c(0,0),c(0,0),c(0,0));
pathl <- list(NULL,NULL,NULL,NULL);
sizel <- list(2, 1.4, 1, 0.7, 0.4, 0.25);
png(filename="frame_%04d.png");
par(mar=c(0.5,0.5,0.5,0.5));
for(cycle in 1:8){
    cat(cycle,"\n");
    for(t in seq(0,2*pi,length.out=60)){
        plot(NA, xlim=c(-1,1), ylim=c(-1,1), axes=FALSE, ann=FALSE);
        points(x=cos(seq(0,2*pi, length.out=100)), col="#000000",
               y=sin(seq(0,2*pi, length.out=100)), type="l", lwd=2);
        points(x=0.9*cos(seq(0,2*pi, length.out=100)), col="#808080",
               y=0.9*sin(seq(0,2*pi, length.out=100)), type="l", lwd=2);
        points(x=0, y=0, type="p", col="#208000", pch=19);
        for(p in seq_along(epl)){
            ep <- epl[[p]];
            ap <- apl[[p]];
            psize <- sizel[[p]];
            path <- pathl[[p]];
            points(path, type="p", col="#80808080", pch=19,
                   cex=seq(0.1, psize, length.out=100));
            t <- round(t / (pi/4)) * (pi/4);
            px <- c(cos(t), sin(t));
            points(cos(t), sin(t), pch=21, cex=2, bg="blue", col="black");
            fv <- sqrt(sum((px-ep) * (px-ep))) / psize;
            fx <- fv * cos(t) * 0.5;
            fy <- fv * sin(t) * 0.5;
            if((abs(fx) > 0) || (abs(fy) > 0)){
                if(abs(fx) < 0.01){
                    arrows(x0=ep[1], y0=ep[2], col="#00000020",
                           x1=ep[1], y1=ep[2]+fy, length=0.1);
                } else if(abs(fy) < 0.01){
                    arrows(x0=ep[1], y0=ep[2], col="#00000020",
                           x1=ep[1]+fx, y1=ep[2], length=0.1);
                } else {
                    arrows(x0=rep(ep[1],2), y0=rep(ep[2],2), col="#00000020",
                           x1=ep[1]+c(fx,0), y1=ep[2]+c(0,fy), length=0.1);
                }
            }
            ap[1] <- ap[1] + fx/0.3 * 0.001;
            ap[2] <- ap[2] + fy/0.3 * 0.001;
            ep[1] <- ep[1] + ap[1];
            ep[2] <- ep[2] + ap[2];
            path <- tail(rbind(path, ep), 100);
            if(sqrt(sum(ep*ep)) > 0.9){
                ep <- c(0,0);
                ap <- c(0,0);
                path <- c(0,0);
            }
            Sys.sleep(0.03);
            epl[[p]] <- ep;
            apl[[p]] <- ap;
            pathl[[p]] <- path;
        }
        for(p in seq_along(epl)){
            ep <- epl[[p]];
            ap <- apl[[p]];
            psize <- sizel[[p]];
            path <- pathl[[p]];
            points(ep[1], ep[2], pch=21, bg="red", col="black",
                   cex=psize);
        }
    }
}
invisible(dev.off());
