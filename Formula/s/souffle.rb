class Souffle < Formula
  desc "Logic Defined Static Analysis"
  homepage "https://souffle-lang.github.io"
  url "https://github.com/souffle-lang/souffle/archive/refs/tags/2.4.1.tar.gz"
  sha256 "08d9b19cb4a8f570ac75dea73016b6a326d87ac28fccd4afeba217ace2071587"
  license "UPL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "afd929227d4b2b7a6424186c7ae61838e105eee0c1d3ef6aa8d47c9c995bb6b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "57c853a352feed0ea976729ac5e299b2422e122f42a9f29e264339586ee8e5a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "91fa45ba6431efada4dd59f7876f3ddbc7ccc6e320f1f71104f5c6be6eb97e7d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c23a5cca7622755bea778b9c42645b2ffd747bb385f16e4397d359a6acdd357"
    sha256 cellar: :any_skip_relocation, sonoma:         "eb94390d08fcf1eeaecab9000dd2bfbbec9c079d6dc5df593acdab40d39d1649"
    sha256 cellar: :any_skip_relocation, ventura:        "c02a77b4ec1e0c746c6d0e59aa33664110d07ed3a6a07d5cbe03cb861d854615"
    sha256 cellar: :any_skip_relocation, monterey:       "2992254dd9a9e5c8fca4f7cd3050907a26dd37eb646aa9fff28d0f2eafe5b98f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59037bee47f85f284d68fc8c57ee8703d1d79e34c6c2ffeaa004d81cf61230e1"
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
    system bin/"souffle", "-F", "#{testpath}/.", "-D", "#{testpath}/.", "#{testpath}/example.dl"
    assert_predicate testpath/"path.csv", :exist?
    assert_equal "1,2\n", shell_output("cat #{testpath}/path.csv")
  end
end
