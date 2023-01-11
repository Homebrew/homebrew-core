class Souffle < Formula
  desc "Logic Defined Static Analysis"
  homepage "https://souffle-lang.github.io"
  url "https://github.com/souffle-lang/souffle/archive/refs/tags/2.3.tar.gz"
  sha256 "db03f2d7a44dffb6ad5bc65637e5ba2b7c8ae6f326d83bcccb17986beadc4a31"
  license "UPL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1331fbbd0231070f1c2c45748d442100992a4127b4c09b7ade363a47b4ff4502"
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0a441bcb1b6ddb8c5695a8c9473bd507841f37eddd94e117c637a035d3d8d15b"
    sha256 cellar: :any_skip_relocation, ventura:       "b704be498ec7a7f69afbf1b9466caed8a3f20f599bf5cd11dfe1d985a5c89c7d"
    sha256 cellar: :any_skip_relocation, monterey:      "8a15d900785b447834ff525d837bde5976abdd7fdac46e99224e6d7604ebcd4c"
    sha256 cellar: :any_skip_relocation, big_sur:       "54359b0756972ca99d438dd8cbd72a49dfe93b53ee3c1731e7b32931973b5bfc"
  end

  depends_on "bison" => :build 
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libffi" => :build
  depends_on "flex" => :build
  depends_on "mcpp" => :build
  depends_on "swig" 
  depends_on "libomp"
  depends_on "ncurses"
  depends_on "sqlite"
  depends_on "zlib"
  depends_on "gcc"

  def install
    cmake_args = [
      "-DCMAKE_CXX_COMPILER=#{Formula["gcc"].bin}/g++-#{Formula["gcc"].version.major}",
      "-DSOUFFLE_GIT=OFF",
      "-DSOUFFLE_BASH_COMPLETION=ON",
      "-DBASH_COMPLETION_COMPLETIONSDIR=#{bash_completion}",
      "-DSOUFFLE_VERSION=#{version}",
      "-DPACKAGE_VERSION=#{version}",
    ]
    system "cmake", "-S", ".", "-B", "build", *cmake_args, *std_cmake_args
    inreplace "#{buildpath}/build/src/souffle-compile.py" do |s|
      sqlite_include = "#{Formula["sqlite"].opt_include}"
      lib_ext = ".so"
      lib_ext = ".dylib" if OS.mac?
      link_options = [
        "#{Formula["sqlite"].opt_lib}/libsqlite3#{lib_ext}",
        "#{Formula["zlib"].opt_lib}/libz#{lib_ext}",
        "#{Formula["ncurses"].opt_lib}/libncurses#{lib_ext}",
      ]
      if OS.linux?
        link_options << "-ldl"
      end
      rpaths = [
        "#{Formula["sqlite"].opt_lib}",
        "#{Formula["zlib"].opt_lib}",
        "#{Formula["ncurses"].opt_lib}",
      ]
      s.gsub!("#{Formula["sqlite"].opt_lib}", "#{Formula["sqlite3"].opt_lib}")
      s.gsub!(/"includes": ".*?"/, "\"includes\": \"-I#{include} -I#{sqlite_include}\"")
      s.gsub!(/"link_options": ".*?"/, "\"link_options\": \"#{link_options * " "}\"")
      s.gsub!(/"rpaths": ".*?"/, "\"rpaths\": \"#{rpaths * ":"}\"")
      s.gsub!(/"source_include_dir": ".*?"/, "\"source_include_dir\": \"#{include}\"")
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
    rm testpath/"path.csv"

    system "#{bin}/souffle", "-o", "example", "#{testpath}/example.dl"
    assert_predicate testpath/"example", :exist?
    system "./example", "-F", "#{testpath}/.", "-D", "#{testpath}/."
    assert_predicate testpath/"path.csv", :exist?
    assert_equal "1,2\n", shell_output("cat #{testpath}/path.csv")
  end
end
