#! /usr/bin/perl -w

#############################################################################

# Here, we make a map from transform names to line styles, so that each
# transform is plotted in a consistent style.  Which style we assign to
# which FFT is fairly arbitrary, but we should try to make FFTs that are
# close in performance visually distinct on the graph.

# A style consists of (: separated):
#   line-color:line-style:line-width
#   :symbol-color:symbol-shape:symbol-size:symbol-fill-color

# The colors can be any one of:
#    none, white, black, red, green, blue, yellow, brown, grey, violet,
#          cyan, magenta, orange, indigo, maroon, turquoise, green4

# The line-style can be any one of:
#    none, solid, dot, dash, dash2, dotdash, dotdash2, dotdotdash, dotdashdash

# The symbol-shape can be any one of:
#    none, circle, square, diamond, triangle-up, triangle-down, 
#    triangle-right, plus, x, star, '<char>'
# ('<char>' indicates that the letter given by <char> is used as the symbol)

# (The default symbol-size/line-width is 1.0.)

%styles = (
	   "arndt-4step" => "yellow:solid:2:yellow:circle:0.25:none",
	   "arndt-dif" => "yellow:solid:1:yellow:circle:0.5:none",
	   "arndt-dit" => "yellow:solid:1:yellow:circle:0.5:yellow",
	   "arndt-fht" => "yellow:dot:1:yellow:triangle-up:0.5:none",
	   "arndt-ndim" => "yellow:dash:1:yellow:star:1:none",
	   "arndt-split" => "yellow:dotdotdash:1:yellow:square:0.7:none",
	   "arndt-twodim" => "yellow:dot:1:yellow:diamond:0.7:none",
	   "athfft" => "indigo:dot:1:indigo:circle:0.5:none",
	   "bloodworth" => "red:dot:1:red:square:0.5:none",
	   "bloodworth-fht" => "red:solid:1:red:square:0.5:red",
	   "burrus-sffteu" => "violet:solid:1:violet:x:0.5:none",
	   "cwplib" => "orange:dotdash:1:orange:square:0.5:none",
	   "dfftpack" => "brown:dash:1:brown:triangle-right:0.5:none",
	   "djbfft-0.76" => "maroon:solid:1:maroon:square:0.5:none",
	   "dsp79-rader" => "yellow:solid:1:yellow:circle:0.5:none",
	   "dsp79-FAST" => "yellow:dot:1:yellow:circle:0.5:yellow",
	   "dsp79-FFA" => "yellow:solid:1:yellow:square:0.5:none",
	   "dsp79-FFT842" => "yellow:dot:1:yellow:triangle-up:0.5:none",
	   "dsp79-singleton" => "yellow:solid:1:yellow:star:0.5:none",
	   "dsp79-wfta" => "yellow:dash:1:yellow:diamond:0.5:none",
	   "dsp79-morris" => "yellow:dotdash:1:yellow:diamond:0.5:yellow",
	   "dxml" => "black:solid:1:black:star:0.5:none",
	   "emayer" => "turquoise:dot:1.5:turquoise:plus:0.5:none",
	   "essl" => "black:solid:1:black:star:0.5:none",
	   "fftpack" => "brown:dash:1:brown:triangle-right:0.5:brown",
	   "fftw2-measure" => "cyan:solid:1:cyan:circle:0.5:cyan",
	   "fftw2-estimate" => "cyan:solid:1:cyan:circle:0.5:none",
	   "fftw2-nd-measure" => "cyan:dash:1:cyan:circle:0.5:cyan",
	   "fftw2-nd-estimate" => "cyan:dash:1:cyan:circle:0.5:none",
	   "fftw3" => "blue:solid:1:blue:circle:0.5:blue",
	   "goedecker" => "brown:solid:2:brown:circle:0.25:none",
	   "gpfa" => "maroon:dash:1:maroon:diamond:0.5:none",
	   "gpfa-3d" => "maroon:dash:1:maroon:diamond:0.5:none",
	   "green-ffts-2.0" => "green:solid:2:green:circle:0.25:green",
	   "gsl-mixed-radix" => "violet:solid:2:violet:circle:0.25:none",
	   "gsl-radix-2" => "violet:dash:1:violet:circle:0.5:violet",
	   "gsl-radix-2-dif" => "violet:dash:1:violet:star:0.5:none",
	   "gsl-radix-2-dit" => "violet:dot:1:violet:circle:0.5:none",
	   "harm" => "green4:dot:1:green4:star:0.5:none",
	   "intel-mkl32-def" => "black:solid:1:black:circle:0.5:black",
	   "intel-mkl32-f-def" => "black:dash:1:black:circle:0.5:none",
	   "intel-mkl32-p3" => "black:dotdash:1:black:triangle-up:0.5:black",
	   "intel-mkl32-f-p3" => "black:dot:1:black:triangle-up:0.5:none",
	   "intel-mkl32-p4" => "black:dotdash:1:black:triangle-up:0.5:black",
	   "intel-mkl32-f-p4" => "black:dot:1:black:triangle-up:0.5:none",
	   "intel-mkl64-itp" => "black:dotdash:1:black:triangle-up:0.5:black",
	   "intel-mkl64-f-itp" => "black:dot:1:black:triangle-up:0.5:none",
	   "krukar" => "cyan:dash:1:cyan:triangle-up:0.5:none",
	   "mfft" => "orange:solid:2:orange:circle:0.25:none",
	   "mixfft" => "blue:dot:1:blue:star:0.5:none",
	   "bailey" => "green4:dot:1:green4:square:0.5:green4",
	   "mpfun77" => "green4:dot:1:green4:square:0.5:green4",
	   "mpfun90" => "green4:dash:1:green4:square:0.5:none",
	   "nag-cmplx" => "red:dot:1:red:square:0.5:red",
	   "nag-workspace" => "red:dash:1:red:square:0.5:none",
	   "nag-inplace" => "red:dot:1:red:triangle-right:0.5:red",
	   "nag-multiple" => "red:dash:1:red:circle:0.5:none",
	   "ooura-sg" => "magenta:solid:1:magenta:star:1.0:none",
	   "ooura-8g" => "magenta:dot:1:magenta:circle:0.5:none",
	   "ooura-8gf" => "magenta:dot:1:magenta:circle:0.5:magenta",
	   "ooura-4g" => "magenta:dash:1:magenta:triangle-up:0.5:none",
	   "ooura-4gf" => "magenta:dash:1:magenta:triangle-up:0.5:magenta",
	   "qft" => "violet:solid:1:violet:plus:0.5:none",
	   "rmayer-ctrig" => "orange:solid:1:orange:circle:0.25:none",
	   "rmayer-buneman" => "orange:dot:1:orange:circle:0.5:none",
	   "rmayer-buneman2" => "orange:dot:1:orange:triangle-up:0.5:none",
	   "rmayer-buneman3" => "orange:dot:1:orange:star:0.5:none",
	   "rmayer-simple" => "orange:dash:1:orange:diamond:0.5:orange",
	   "rmayer-unstable" => "orange:dash:2:orange:diamond:0.5:none",
	   "rmayer-lookup" => "orange:solid:1:orange:triangle-down:0.5:none",
	   "sgimath" => "black:solid:1:black:star:0.5:none",
	   "singleton" => "red:solid:1:red:triangle-up:0.5:none",
	   "singleton-3d" => "red:solid:1:red:triangle-up:0.5:none",
	   "sorensen-ctfftsr" => "indigo:dot:2:indigo:circle:0.25:none",
	   "sorensen-rsrfft" => "indigo:solid:1:indigo:diamond:0.5:indigo",
	   "sorensen-sfftfu" => "indigo:dash:1:indigo:x:0.5:none",
	   "sunperf" => "black:solid:1:black:star:0.5:none",
	   "temperton" => "grey:solid:2:black:circle:0.25:none",
	   "vdsp" => "black:solid:1:black:star:0.5:none",
	   "vDSP" => "black:solid:1:black:star:0.5:none",
	   );

%symbols = ("none" => 0, "circle" => 1, "square" => 2, "diamond" => 3,
	    "triangle-up" => 4, "triangle-left" => 5, "triangle-down" => 6,
	    "triangle-right" => 7, "plus" => 8, "x" => 9, "star" => 10, 
	    "char" => 11);

%linestyles = ("none" => 0, "solid" => 1, "dot" => 2, "dash" => 3,
	       "dash2" => 4, "dotdash" => 5, "dotdash2" => 6,
	       "dotdotdash" => 7, "dotdashdash" => 8);

sub printstyle {
    my $style = shift;
    my $setnum = shift;
    my ($linecolor,$linestyle,$linewidth,$symbolcolor,$symbolshape,
	$symbolsize,$symbolfillcolor) = split(/:/,$style);
    if ($linecolor eq "none" || $linestyle eq "none") {
	print "@ s$setnum linestyle ",$linestyles{"none"},"\n";
    }
    else {
	print "@ s$setnum linestyle $linestyles{$linestyle}\n";
	print "@ s$setnum linewidth $linewidth\n";
	print "@ s$setnum line color \"$linecolor\"\n";
    }
    if ($symbolcolor ne "none") {
	# note: '<char>' symbols are not yet implemented here.
	print "@ s$setnum symbol $symbols{$symbolshape}\n"; 
	print "@ s$setnum symbol color \"$symbolcolor\"\n";
	print "@ s$setnum symbol size $symbolsize\n";
	if ($symbolfillcolor ne "none") {
	    print "@ s$setnum symbol fill pattern 1\n";
	    print "@ s$setnum symbol fill color \"$symbolfillcolor\"\n";
	}
    }
}

#############################################################################

print "@ xaxis label \"transform size\"\n";
print "@ yaxis label \"speed (mflops)\"\n";

$max_mflops = 0;

# Collect the data:
while (<>) {
  ($nam, $prob, $siz, $mflops, $tim) = split / /;
  $tot = $siz;
  $tot =~ s/x/*/g;
  $tot = eval($tot);

  $sizes{$tot} = $siz;
  $tots{$siz} = $tot;

  if (! exists($best_mflops{$siz}) || $best_mflops{$siz} < $mflops) {
      $best_mflops{$siz} = $mflops;
  }
  if ($mflops > $max_mflops) { $max_mflops = $mflops };

  if (! exists($problems{$nam})) { $problems{$nam} = $prob; }
  elsif ($problems{$nam} ne $prob) { $problems{$nam} = "several"; }

  $transform = "$nam:$prob";
  if (! exists($results{$transform})) { 
      $results{$transform} = "$siz:$mflops";
  }
  else {
      $results{$transform} = $results{$transform} . " $siz:$mflops";
  }
}

# Set y axis scale from $max_mflops:
$mflops_increment = 100; # increment for y-axis labels
$max_mflops =~ s/\..*//;
$max_mflops = $max_mflops + $mflops_increment - 1 - ($max_mflops + $mflops_increment - 1) % $mflops_increment;
print "@ world ymin 0\n";
print "@ world ymax $max_mflops\n";
print "@ yaxis tick major $mflops_increment\n";
print "@ yaxis tick minor color \"grey\"\n";
print "@ yaxis tick major color \"grey\"\n";
print "@ yaxis tick major grid on\n";
print "@ xaxis tick major color \"grey\"\n";
print "@ xaxis tick major grid on\n";
print "@ autoscale onread xaxes\n";

# Set x axis ticks and labels:
print "@ xaxis ticklabel angle 270\n";
print "@ xaxis ticklabel type spec\n";
print "@ xaxis tick type spec\n";
@totals = sort { $a - $b } keys(%sizes);
print "@ xaxis tick spec ", 1 + $#totals, "\n";
$ticknum = 0;
foreach $tot (@totals) {
    print "@ xaxis tick major $ticknum, $ticknum\n";
    print "@ xaxis ticklabel $ticknum, \"",$sizes{$tot},"\"\n";
    $xval{$tot} = $ticknum;
    $ticknum = $ticknum + 1;
}

# add grid lines?

# Make sure results are sorted in increasing order of xval, or grace will
# connect the dots strangely:
foreach $transform (keys %results) {
    $results{$transform} = join(" ", sort { 
	($siz_a, $mflops_a) = split(/:/,$a);
	($siz_b, $mflops_b) = split(/:/,$b);
	$xval{$tots{$siz_a}} - $xval{$tots{$siz_b}};
    } split(/ /,$results{$transform}));
}

# Compute the "normalized speed" of each transform, for sorting purposes:
@norm_speeds = ();
foreach $transform (keys %results) {
    $norm_speed = "";
    foreach $speed (split(/ /, $results{$transform})) {
	($siz, $mflops) = split(/:/,$speed);
	$norm_speed = $norm_speed . " " .  ($mflops / $best_mflops{$siz});
    }
    $num_speeds = 1 + ($norm_speed =~ s/ /+/g);
    $norm_speed = eval($norm_speed) / $num_speeds;
    $norm_speeds[$#norm_speeds + 1] = $norm_speed;
    $transforms{$norm_speed} = $transform;
}

# Print out the data sets for each transform, in descending order of "speed":
$setnum = 0;
foreach $norm_speed (sort { 100000 * ($b - $a) } @norm_speeds) {
    $transform = $transforms{$norm_speed};
    ($nam, $prob) = split(/:/,$transform);

    # legend should include the problem if this transform solves more than
    # one problem in this data:
    if ($problems{$nam} ne $prob) {
	print "@ s$setnum legend \"$transform\"\n";
    }
    else {
	print "@ s$setnum legend \"$nam\"\n";
    }

    if (exists($styles{$nam})) {
	printstyle($styles{$nam}, $setnum);
    }

    print "@ target s$setnum\n";
    foreach $speed (split(/ /, $results{$transform})) {
	($siz, $mflops) = split(/:/,$speed);
	print "$xval{$tots{$siz}} $mflops\n";
    }
    print "&\n";

    $setnum = $setnum + 1;
}