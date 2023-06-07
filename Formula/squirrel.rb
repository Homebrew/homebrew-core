class Squirrel < Formula
  desc "High level, imperative, object-oriented programming language"
  homepage "http://www.squirrel-lang.org"
  url "https://downloads.sourceforge.net/project/squirrel/squirrel3/squirrel%203.2%20stable/squirrel_3_2_stable.tar.gz"
  sha256 "211f1452f00b24b94f60ba44b50abe327fd2735600a7bacabc5b774b327c81db"
  license "MIT"
  head "https://github.com/albertodemichelis/squirrel.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{url=.*?/squirrel[._-]v?(\d+(?:[_-]\d+)+)[._-]stable\.t}i)
    strategy :sourceforge do |page, regex|
      page.scan(regex).map { |match| match.first.tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "631ffa6eed034f912c1a23b1f52cca805632e175caa1a1dc22a4a7718fc61fe1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a1b1eaad58270a2b924e75720f9c3a1ce63ca408868ce31637e26fd27d66062"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0b4a46f4bce39d747dcf5e7ec4ee43afc76646ae6f4e8c0e7ae1601d147061f5"
    sha256 cellar: :any_skip_relocation, ventura:        "9bd02555a226495fcb30c9f539359be571890111c920318f430ecca760c46cc0"
    sha256 cellar: :any_skip_relocation, monterey:       "c8822588938ec4e83897e6f883ccfad6f39ae6fff7279ea35e988a39c2da4c10"
    sha256 cellar: :any_skip_relocation, big_sur:        "bb230ed7a9aa535e40bbe4f127cd6d4325fed6be46b4a4dae58c39d01b169666"
    sha256 cellar: :any_skip_relocation, catalina:       "749bb90e798990994fa79d8846661f95fa7e150d3606b889c0351697c82add62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "747575d9f05e9496d0eecf8ea4d6db59711396eac5feca1ae2f61794a53a6a64"
  end

  def install
    # The tarball files are in a subdirectory, unlike the upstream repository.
    # Moving tarball files out of the subdirectory allows us to use the same
    # build steps for stable and HEAD builds.
    squirrel_subdir = "squirrel#{version.major}"
    if Dir.exist?(squirrel_subdir)
      mv Dir["squirrel#{version.major}/*"], "."
      rmdir squirrel_subdir
    end

    system "make"
    prefix.install %w[bin include lib]
    doc.install Dir["doc/*.pdf"]
    doc.install %w[etc samples]
    # See: https://github.com/Homebrew/homebrew/pull/9977
    (lib+"pkgconfig/libsquirrel.pc").write pc_file
  end

  def pc_file
    <<~EOS
      prefix=#{opt_prefix}
      exec_prefix=${prefix}
      libdir=/${exec_prefix}/lib
      includedir=/${prefix}/include
      bindir=/${prefix}/bin
      ldflags=  -L/${prefix}/lib

      Name: libsquirrel
      Description: squirrel library
      Version: #{version}

      Requires:
      Libs: -L${libdir} -lsquirrel -lsqstdlib
      Cflags: -I${includedir}
    EOS
  end

  test do
    (testpath/"hello.nut").write <<~EOS
      print("hello");
    EOS
    assert_equal "hello", shell_output("#{bin}/sq #{testpath}/hello.nut").chomp
  end
end
