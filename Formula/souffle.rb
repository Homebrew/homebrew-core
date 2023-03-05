class Souffle < Formula
  desc "Logic Defined Static Analysis"
  homepage "https://souffle-lang.github.io"
  url "https://github.com/souffle-lang/souffle/archive/refs/tags/2.4.tar.gz"
  sha256 "951f12272023dd3a1b398318ab24eb567bebad1d5f5b623e89c088e1418836af"
  license "UPL-1.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3b1853e3a70ec76c6ca4d257a253cba8582cfbca1fc80c06fad7b42b6328f135"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c1f4a719ceb130824a49acde3de6cd541061451f18933d14bbe2cdea937728a2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "144fb3fa8aa3b1d790bf852546ddfc0e8bc318e7bbfc5ce04794a51ef9fb7adc"
    sha256 cellar: :any_skip_relocation, ventura:        "8581f4a69c3976be0b59f020d31479e09c789e451bd2aeb630a3624c9a2b9a58"
    sha256 cellar: :any_skip_relocation, monterey:       "e0aee7dd23a81e2d0ac981711a5518fb74f61c1dc769b1082e4e354915c64c28"
    sha256 cellar: :any_skip_relocation, big_sur:        "3e09e3883678bc524d7162c1b59a7175f654f33476a8a4cb8c56e1c7c05c62b6"
  end

  depends_on "bison" => :build # Bison included in macOS is out of date.
  depends_on "cmake" => :build
  depends_on "mcpp" => :build
  depends_on "pkg-config" => :build
  depends_on macos: :catalina
  uses_from_macos "flex" => :build
  uses_from_macos "libffi"
  uses_from_macos "ncurses"
  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  def install
    cmake_args = [
      "-DSOUFFLE_DOMAIN_64BIT=ON",
      "-DSOUFFLE_GIT=OFF",
      "-DSOUFFLE_BASH_COMPLETION=ON",
      "-DBASH_COMPLETION_COMPLETIONSDIR=#{bash_completion}",
      "-DSOUFFLE_VERSION=#{version}",
      "-DPACKAGE_VERSION=#{version}",
    ]
    system "cmake", "-S", ".", "-B", "build", *cmake_args, *std_cmake_args
    inreplace "#{buildpath}/build/src/souffle-compile.py" do |s|
      s.gsub!(/"compiler": ".*?"/, "\"compiler\": \"/usr/bin/c++\"")
      s.gsub!(%r{-I.*?/src/include }, "")
      s.gsub!(%r{"source_include_dir": ".*?/src/include"}, "\"source_include_dir\": \"#{include}\"")
    end
    system "cmake", "--build", "build", "-j", "--target", "install"
    include.install Dir["src/include/*"]
    man1.install Dir["man/*"]
  end

  test do
    (testpath/"example.dl").write <<~EOS
      .decl edge(x:number, y:number)
      .input edge(delimiter=",")

      .decl path(x:number, y:number)
      .output path(delimiter=",")

      path(x, y) :- edge(x, y).
    EOS
    (testpath/"edge.facts").write <<~EOS
      1,2
    EOS
    system "#{bin}/souffle", "-F", "#{testpath}/.", "-D", "#{testpath}/.", "#{testpath}/example.dl"
    assert_predicate testpath/"path.csv", :exist?
    assert_equal "1,2\n", shell_output("cat #{testpath}/path.csv")
  end
end
