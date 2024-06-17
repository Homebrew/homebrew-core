class Sbcl < Formula
  desc "Steel Bank Common Lisp system"
  homepage "https://www.sbcl.org/"
  url "https://downloads.sourceforge.net/project/sbcl/sbcl/2.4.5/sbcl-2.4.5-source.tar.bz2"
  sha256 "4df68e90c9031807642b4b761988deb5bf6a1bd152c4723482834efa735a7bd1"
  license all_of: [:public_domain, "MIT", "Xerox", "BSD-3-Clause"]
  head "https://git.code.sf.net/p/sbcl/sbcl.git", branch: "master"

  livecheck do
    url "https://sourceforge.net/projects/sbcl/rss?path=/sbcl"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6afadb54b3d8bf2ebad9a690b243abe7cf0983940666d22cbde6ce479cca36b3"
    sha256 cellar: :any,                 arm64_ventura:  "605c4612901904a57896891797fba0ffd7dffbe3785a1f243fd0bd78e6865f33"
    sha256 cellar: :any,                 arm64_monterey: "f8f06a6287033c8f11f837fcb4dbbd252d4686ab29d6e227bc6fb8107ace091a"
    sha256 cellar: :any,                 sonoma:         "81b8f3f3461311e60c013508fb2dd311d5d0ded4108293d0f1cd4a8cfcd2b9f2"
    sha256 cellar: :any,                 ventura:        "ca396738197a0c06f1460617b49e0e0717abded64a0bd2dad29c696c70c64921"
    sha256 cellar: :any,                 monterey:       "2322d4bb94157b75f916eb52f2f57c910ea7dc0f00b86710b12f71c498d54abc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ec909cdfe629fe354f3b088573be92ecea5191cbf6efa8eab00c09c9554416d"
  end

  depends_on "ecl" => :build
  depends_on "zstd"

  def install
    # Remove non-ASCII values from environment as they cause build failures
    # More information: https://bugs.gentoo.org/show_bug.cgi?id=174702
    ENV.delete_if do |_, value|
      ascii_val = value.dup
      ascii_val.force_encoding("ASCII-8BIT") if ascii_val.respond_to? :force_encoding
      ascii_val =~ /[\x80-\xff]/n
    end

    xc_cmdline = "ecl --norc"

    args = [
      "--prefix=#{prefix}",
      "--xc-host=#{xc_cmdline}",
      "--with-sb-core-compression",
      "--with-sb-ldb",
      "--with-sb-thread",
    ]

    ENV["SBCL_MACOSX_VERSION_MIN"] = MacOS.version.to_s if OS.mac?
    system "./make.sh", *args

    ENV["INSTALL_ROOT"] = prefix
    system "sh", "install.sh"

    # Install sources
    bin.env_script_all_files libexec/"bin",
                             SBCL_SOURCE_ROOT: pkgshare/"src",
                             SBCL_HOME:        lib/"sbcl"
    pkgshare.install %w[contrib src]
    (lib/"sbcl/sbclrc").write <<~EOS
      (setf (logical-pathname-translations "SYS")
        '(("SYS:SRC;**;*.*.*" #p"#{pkgshare}/src/**/*.*")
          ("SYS:CONTRIB;**;*.*.*" #p"#{pkgshare}/contrib/**/*.*")))
    EOS
  end

  test do
    (testpath/"simple.sbcl").write <<~EOS
      (write-line (write-to-string (+ 2 2)))
    EOS
    output = shell_output("#{bin}/sbcl --script #{testpath}/simple.sbcl")
    assert_equal "4", output.strip
  end
end
