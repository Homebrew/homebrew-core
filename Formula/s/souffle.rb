class Souffle < Formula
  desc "Logic Defined Static Analysis"
  homepage "https://souffle-lang.github.io"
  url "https://github.com/souffle-lang/souffle/archive/refs/tags/2.5.tar.gz"
  sha256 "5d009ad6c74ccec10207d865c059716afac625759bff7c8070e529bd80385067"
  license "UPL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e5811b6c5a6bf21ff0491e577590568243072a1431adc517a7880106785e9ebd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b2bc7684a7337a00f830ce5d496f15b06e3870a2416737cbd791cb50e399d9c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1df31eac00a747cd74fd31aff745ab4164362cbc737d53264d2b40178a3c2cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "29f023e79b7d2fe1310378dcad026608895475880f80bc050131ea48842a93da"
    sha256 cellar: :any_skip_relocation, sonoma:        "732925d732bd977ad72315894d0f2deadb35a2ac092b4dcc615b699ed3e0e243"
    sha256 cellar: :any_skip_relocation, ventura:       "4287f9391ad73a50eb0c6e578955529a2b36d517f43e60d2e1553114d7ef56b2"
    sha256                               arm64_linux:   "4189ff925d166433ce98ab437c26c913bd62c81e706fa3e82a2858f9ff0ce60f"
    sha256                               x86_64_linux:  "5fd9b1a03f7400bbe208d30058cf4850a03e2c768918f5918a549f277966e9ba"
  end

  depends_on "bison" => :build # Bison included in macOS is out of date.
  depends_on "cmake" => :build
  depends_on "mcpp" => :build
  depends_on "pkgconf" => :build
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
    system "cmake", "--build", "build", "--target", "install"
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
    system bin/"souffle", "-F", "#{testpath}/.", "-D", "#{testpath}/.", "#{testpath}/example.dl"
    assert_path_exists testpath/"path.csv"
    assert_equal "1,2\n", shell_output("cat #{testpath}/path.csv")
  end
end
