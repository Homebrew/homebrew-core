class Souffle < Formula
  desc "Logic Defined Static Analysis"
  homepage "https://souffle-lang.github.io"
  url "https://github.com/souffle-lang/souffle/archive/refs/tags/2.4.tar.gz"
  sha256 "951f12272023dd3a1b398318ab24eb567bebad1d5f5b623e89c088e1418836af"
  license "UPL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9c0cc4fef22fd9d69ce94cbc39d3b4c29818f9202a1df2ae361e4e2786c1934f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad8e61f58dedd5eebccd1a7512f77f15b832e060d46373bec4ed563320da20fb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "660b4427e40bef8305b9883c2a6287d5a04772a59c888d0017c0d1ea33e20cb5"
    sha256 cellar: :any_skip_relocation, ventura:        "f85ce27bdf76085ff1e8828202809dfd6d1d304578fc26e4b2d283105808dd17"
    sha256 cellar: :any_skip_relocation, monterey:       "274a7e2b76855cd451a66fca1b16e68cad6497d127c1f00d8a2254bae4c1ff53"
    sha256 cellar: :any_skip_relocation, big_sur:        "421864326246cf50896f7fe863944c9b0aa26d8cb2fb11a6f987f158adf897ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8d92874c542c5f262ab0b4ba030ace501983e6076fe191194140211159f86a3"
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
