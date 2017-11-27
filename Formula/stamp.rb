class Stamp < Formula
  desc "Structural Alignment of Multiple Proteins"
  homepage "http://www.compbio.dundee.ac.uk/downloads/stamp/"
  url "http://www.compbio.dundee.ac.uk/downloads/stamp/stamp.4.4.2.tar.gz"
  sha256 "1305753d251b6e8d17feb7e28d80ba0ceb47436384dedc910ffafcad7d82dd6e"
  # tag "bioinformatics"

  resource "pdb" do
    url "https://files.rcsb.org/view/2pah.pdb"
    sha256 "8b8b1f971928b3b20ff3755711dd58b4b9fe68f0f9cd023fbdac1c94799fb940"
  end

  def install
    system "./BUILD"
    prefix.install "examples", "defs"
    bin.install Dir["bin/*"]
    doc.install Dir["doc/*"], "LICENSE", "README"
    ENV["STAMPDIR"] = prefix/"defs"
  end

  def caveats; <<~EOS
    A valid STAMPDIR is required to use the STAMP commands.
    You need to add it to your list of ENVIRONMENT variables:
      export STAMPDIR=#{prefix}/defs
    Alternatively, you can point STAMPDIR to a custom copy of
    the STAMP parameter files.
    EOS
  end

  test do
    ENV["STAMPDIR"] = prefix/"defs"

    # STAMP tools were installed
    assert_predicate bin/"stamp", :exist?
    assert_predicate bin/"aconvert", :exist?
    assert_predicate bin/"alignfit", :exist?
    assert_predicate bin/"avestruc", :exist?
    assert_predicate bin/"dstamp", :exist?
    assert_predicate bin/"extrans", :exist?
    assert_predicate bin/"gstamp", :exist?
    assert_predicate bin/"mergestamp", :exist?
    assert_predicate bin/"mergetrans", :exist?
    assert_predicate bin/"pdbc", :exist?
    assert_predicate bin/"pdbseq", :exist?
    assert_predicate bin/"pickframe", :exist?
    assert_predicate bin/"poststamp", :exist?
    assert_predicate bin/"sorttrans", :exist?
    assert_predicate bin/"pickframe", :exist?
    assert_predicate bin/"stamp_clean", :exist?
    assert_predicate bin/"transform", :exist?
    assert_predicate bin/"ver2hor", :exist?

    assert_predicate bin/"stamp", :executable?
    assert_predicate bin/"aconvert", :executable?
    assert_predicate bin/"alignfit", :executable?
    assert_predicate bin/"avestruc", :executable?
    assert_predicate bin/"dstamp", :executable?
    assert_predicate bin/"extrans", :executable?
    assert_predicate bin/"gstamp", :executable?
    assert_predicate bin/"mergestamp", :executable?
    assert_predicate bin/"mergetrans", :executable?
    assert_predicate bin/"pdbc", :executable?
    assert_predicate bin/"pdbseq", :executable?
    assert_predicate bin/"pickframe", :executable?
    assert_predicate bin/"poststamp", :executable?
    assert_predicate bin/"sorttrans", :executable?
    assert_predicate bin/"pickframe", :executable?
    assert_predicate bin/"stamp_clean", :executable?
    assert_predicate bin/"transform", :executable?
    assert_predicate bin/"ver2hor", :executable?

    resource("pdb").stage do
      (testpath/"domain.file").write <<~EOS
        2pah.pdb structure { ALL }
      EOS

      lines1 = [">structure TETRAMERIC HUMAN PHENYLALANINE HYDROXYLASE : All ",
                "VPWFPRTIQELDRFANQILDADHPGFKDPVYRARRKQFADIAYNYRHGQPIPRVEYMEEEKKTWGTVFKTLKSLYKTHAC",
                "YEYNHIFPLLEKYCGFHEDNIPQLEDVSQFLQTCTGFRLRPVAGLLSSRDFLGGLAFRVFHCTQYIRHGSKPMYTPEPDI",
                "CHELLGHVPLFSDRSFAQFSQEIGLASLGAPDEYIEKLATIYWFTVEFGLCKQGDSIKAYGAGLLSSFGELQYCLSEKPK",
                "LLPLELEKTAIQNYTVTEFQPLYYVAESFNDAKEKVRNFAATIPRPFSVRYDPYTQRIEVLDNTQQLKILADSINSEIGI",
                "LCSALQKIKVPWFPRTIQELDRADHPGFKDPVYRARRKQFADIAYNYRHGQPIPRVEYMEEEKKTWGTVFKTLKSLYKTH",
                "ACYEYNHIFPLLEKYCGFHEDNIPQLEDVSQFLQTCTGFRLRPVAGLLSSRDFLGGLAFRVFHCTQYIRHGSKPMYTPEP",
                "DICHELLGHVPLFSDRSFAQFSQEIGLASLGAPDEYIEKLATIYWFTVEFGLCKQGDSIKAYGAGLLSSFGELQYCLSEK",
                "PKLLPLELEKTAIQNYTVTEFQPLYYVAESFNDAKEKVRNFAATIPRPFSVRYDPYTQRIEVLDNTQQLKILADSINSEI",
                "GILCSALQKIK", ""]
      assert_equal lines1.join("\n").sub('\\"', ""), shell_output("#{bin}/pdbseq -f #{testpath}/domain.file -tl 42")

      lines2 = ["Warning: chains aren't considered in this mode",
                "2pah  3.10000 -2.00000 1998 0 0 0     2   651     0", ""]
      assert_equal lines2.join("\n").sub('\\"', ""), shell_output("#{bin}/pdbc -r 2pah.pdb")
    end
  end
end
