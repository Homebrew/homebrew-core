class Wcstools < Formula
  desc "Tools for using World Coordinate Systems (WCS) in astronomical images"
  homepage "http://tdc-www.harvard.edu/wcstools/"
  url "http://tdc-www.harvard.edu/software/wcstools/wcstools-3.9.7.tar.gz"
  sha256 "525f6970eb818f822db75c1526b3122b1af078affa572dce303de37df5c7b088"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?wcstools[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71c2d28775be44e3d583d1058fc42b7ed1facc6d2a47fa0f51a6c4be76642bf9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62c6a1ee4cba5821d4f08ad5996140118ec774432766fde5394a755e3f737b7d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "36f13821bae6872cf2a0efb838b16848747e7a08b9f862696c545c62c571d3e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "1455e3bd5761a326b1d3e9bdce635dbfc10ade55f9e271ac59df798c89bf44be"
    sha256 cellar: :any_skip_relocation, ventura:       "5e8230a3193b604603bdbb35d323ee3161fe96fda6912d4c00d9d67ac7052384"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8cbcde8f555ee9b4399110632e784cadb293066619453e7519b8cd27aa547181"
  end

  def install
    inreplace "Makefile" do |s|
      cflags = s.get_make_var("CFLAGS").split
      cflags.delete("-g")
      cflags.each { |flag| ENV.append_to_cflags flag }
      s.change_make_var!("CFLAGS", ENV.cflags)
    end

    bin.mkpath
    system "make", "BIN=#{bin}", "all"
    bin.install "wcstools"
    man1.install buildpath.glob("man/man1/*.1")
  end

  test do
    assert_match "IMHEAD", shell_output("#{bin}/imhead 2>&1", 1)
  end
end
