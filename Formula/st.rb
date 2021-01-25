class St < Formula
  desc "Statistics from the command-line"
  homepage "https://github.com/nferraz/st"
  url "https://github.com/nferraz/st/archive/v1.1.4.tar.gz"
  sha256 "c02a16f67e4c357690a5438319843149fd700c223128f9ffebecab2849c58bb8"
  license "MIT"
  revision 1
  head "https://github.com/nferraz/st.git"

  livecheck do
    url :head
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "b852dedd2a66d7f03314cf510cf9d94e55c3437a7d23ac0bf7b1742b2d635dda" => :big_sur
    sha256 "b20ec315e5d16adc7acdfbcdcfffd91859a39bcfc5e76e9a152da3dac178c4d3" => :arm64_big_sur
    sha256 "47e88ee3a995fb7f0dc9a5900a378c254c5be13ebfeee44474be9649992d4a5f" => :catalina
    sha256 "a405a6128674652c728e7af64d751388b6ecea693d780efc2ebcfa62ec8e0f6a" => :mojave
  end

  def install
    ENV.prepend_create_path "PERL5LIB", lib/"perl5/"

    system "perl", "Makefile.PL", "INSTALL_BASE=#{prefix}", "INSTALLSITEMAN1DIR=#{man1}", "INSTALLSITEMAN3DIR=#{man3}"
    system "make", "install"

    bin.env_script_all_files libexec/"bin", PERL5LIB: ENV["PERL5LIB"]
  end

  test do
    (testpath/"test.txt").write((1..100).map(&:to_s).join("\n"))
    assert_equal "5050", pipe_output("#{bin}/st --sum test.txt").chomp
  end
end
