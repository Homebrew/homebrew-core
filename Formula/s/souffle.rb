class Souffle < Formula
  desc "Logic Defined Static Analysis"
  homepage "https://souffle-lang.github.io"
  url "https://github.com/souffle-lang/souffle/archive/refs/tags/2.5.tar.gz"
  sha256 "5d009ad6c74ccec10207d865c059716afac625759bff7c8070e529bd80385067"
  license "UPL-1.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9f47ca5761cd191ab3adfc4c9fbe1d9377faeed4b0a650ccdbc1143f18c31b10"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb1d96230756607da2975eb34cc009b26c60d83db1bb208c08dca77aa91c3202"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "267ae9e05421940f911a4d2c5a232ead5488653bb17fa08b98675fa337fb8a3e"
    sha256 cellar: :any_skip_relocation, sonoma:        "e288491afc7774e88e0ae89ce61c994e7311ad04fd5a5cf28e6581a3c29f3493"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9a1eea8ebd69b2091c22e5e5e352f9f37748041848a7fcbf140e96fecc7dccb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98ee8cb076fe6445ca477511c59ff7407731abd8fe1e8612e1e2d249e86b6526"
  end

  depends_on "bison" => :build # Bison included in macOS is out of date.
  depends_on "cmake" => :build
  depends_on "mcpp" => :build
  depends_on "pkgconf" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "libffi"
  uses_from_macos "ncurses"
  uses_from_macos "sqlite"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
    system bin/"souffle", "-F", testpath/".", "-D", testpath/".", testpath/"example.dl"
    assert_path_exists testpath/"path.csv"
    assert_equal "1,2\n", shell_output("cat #{testpath}/path.csv")
  end
end
