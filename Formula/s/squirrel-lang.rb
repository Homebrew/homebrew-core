class SquirrelLang < Formula
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

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a6f3d550f92933219ee049367a983388c573214b498782f3b53b78b1d0b4aaa4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c69026132fadde7bb41e0e27e9b59a697bf8cd34890b2533decb9a5bf577f08c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc0172703a066072344effffa54a83bfa9cb9ed019e1dce5f95d555479d32d66"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c7e75c2f1186ed55390936d42640165a9d14e7545850d8a0e36429b385f75611"
    sha256 cellar: :any_skip_relocation, sonoma:        "a6cbfceef8cc3dd290df3502851c6825d556e1de243577a77e1d5ec791d53e2c"
    sha256 cellar: :any_skip_relocation, ventura:       "84b89afca8ac2aebb170f9465f60338bde3bea89f6fa5ef94b0d59c3e16147ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a93f8baacd46111ca23a759b1982217b9f17b9191f638c6cd8773d377f1d6b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9107cb3585f85f4bed3a63a5f0ab579c559b805b316e955c4e1ee6e8fa23685"
  end

  conflicts_with "sq", because: "both install `sq` binaries"

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
    (lib/"pkgconfig/libsquirrel.pc").write pc_file
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
