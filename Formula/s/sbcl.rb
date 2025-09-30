class Sbcl < Formula
  desc "Steel Bank Common Lisp system"
  homepage "https://www.sbcl.org/"
  url "https://downloads.sourceforge.net/project/sbcl/sbcl/2.5.9/sbcl-2.5.9-source.tar.bz2"
  sha256 "d1b19022d43dc493edc972b6e59c93ae6684c963fdd2b413b0965e18cd6bd1e2"
  license all_of: [:public_domain, "MIT", "Xerox", "BSD-3-Clause"]
  head "https://git.code.sf.net/p/sbcl/sbcl.git", branch: "master"

  livecheck do
    url "https://sourceforge.net/projects/sbcl/rss?path=/sbcl"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e5ebdbae645da83004d76da409b60439d668270479993366a17204abff4807cb"
    sha256 cellar: :any,                 arm64_sequoia: "2a93f06dc762f29b7016ce32b6e4fa9e4738cbf310b1100bc374f730113964e8"
    sha256 cellar: :any,                 arm64_sonoma:  "f15f1124095078946be53d9451cf9c8f80c16bdcafd8041a806c74912a113af8"
    sha256 cellar: :any,                 sonoma:        "5e5e448bee93597c7f2ed0898f6eff4ea3670f4c2236847b69af788989b2e353"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a6a45006848533eb3b95c9d567fb73abb145715bdd595b4235c4397c94d9ce79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a4634f66dce380175caeb1ba30432e1afc7052b556f1a7050ba948e102fd09c"
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
    (lib/"sbcl/sbclrc").write <<~LISP
      (setf (logical-pathname-translations "SYS")
        '(("SYS:SRC;**;*.*.*" #p"#{pkgshare}/src/**/*.*")
          ("SYS:CONTRIB;**;*.*.*" #p"#{pkgshare}/contrib/**/*.*")))
    LISP
  end

  test do
    (testpath/"simple.sbcl").write <<~LISP
      (write-line (write-to-string (+ 2 2)))
    LISP
    output = shell_output("#{bin}/sbcl --script #{testpath}/simple.sbcl")
    assert_equal "4", output.strip
  end
end
