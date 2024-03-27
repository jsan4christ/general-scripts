
seqkit grep -vrp "ref_" cluster85wRefs_uniq_aln.fasta11.rdp5.rrr.fas > cluster85wRefs_uniq_aln.fasta11.rdp5.rrr_nr.fas
seqkit grep -vrp "ref_" cluster85wRefs_uniq_aln.fasta12.rdp5.rrr.fas > cluster85wRefs_uniq_aln.fasta12.rdp5.rrr_nr.fas
seqkit grep -vrp "ref_"  cluster85wRefs_uniq_aln.fasta13.rdp5_gag.rrr.fas > cluster85wRefs_uniq_aln.fasta13.rdp5_gag_nr.rrr.fas
seqkit grep -rvp "ref_"  cluster85wRefs_uniq_aln.fasta14.rdp5.rrr.fas > cluster85wRefs_uniq_aln.fasta14.rdp5.rrr_nr.fas

##
grep -c ">" cluster85wRefs_uniq_aln.fasta11.rdp5.rrr_nr.fas

grep ">" cluster85wRefs_uniq_aln.fasta14.rdp5.rrr_nr.fas | cut -d "/" -f1 | sed "s/>//" | sort| uniq
Sweden, Taiwan, Tanzania, Thailand, Uganda, UnitedKingdom, UnitedStates, Uruguay, Yemen, Zambia

grep ">" cluster85wRefs_uniq_aln_srt_nr.fasta10 | cut -d "/" -f1 | sed "s/>//" | sort| uniq
sequences from Botswana, Brazil, Bulgaria, Cameroon, China, Cyprus, Denmark, Ethiopia, France, Georgia, Germany, India, Israel, Italy, Kenya, Malawi, Mozambique, Nepal, Nigeria, Pakistan, RepublicoftheCongo, Rwanda, Senegal, Somalia, SouthAfrica, Spain, Sweden, Zambia


Phu
https://academic.oup.com/ve/article/7/2/veab055/6295513#403335473


modeltest−ng −i example−data/dna/tiny.fas -t ml

seqkit grep -rvp "ref_" cluster85wRefs_aln.uniq.fasta00 > cluster85wRefs_aln.uniq.fasta00.a
seqkit grep -rp "ref_" cluster85wRefs_aln.uniq.fasta00 > cluster85wRefs_aln.uniq.fasta00.b
cat cluster85wRefs_aln.uniq.fasta00.b cluster85wRefs_aln.uniq.fasta00.a > cluster85wRefs_aln.uniq_srt.fasta00
rm cluster85wRefs_aln.uniq.fasta00.b cluster85wRefs_aln.uniq.fasta00.a