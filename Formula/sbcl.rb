class Sbcl < Formula
  desc "Steel Bank Common Lisp system"
  homepage "http://www.sbcl.org/"
  url "https://downloads.sourceforge.net/project/sbcl/sbcl/2.1.2/sbcl-2.1.2-source.tar.bz2"
  sha256 "b7710550939855ed49598c4a014483ed120b6991658a2a3b6afa47713dce4c0b"
  license all_of: [:public_domain, "MIT", "Xerox", "BSD-3-Clause"]
  head "https://git.code.sf.net/p/sbcl/sbcl.git", shallow: false

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d915b3200cbce70f8fa0ee4e490bb48b2e8c821870c3b5e640b4ad34741665eb"
    sha256 cellar: :any_skip_relocation, big_sur:       "4b72ee3689681c976edd70bdf8260dccfc8a91af597a9bc3bb00cb9adaceea5e"
    sha256 cellar: :any_skip_relocation, catalina:      "6b9e2e3539da50cbdb40cd33e8cf1bbd3414a2c4ac1af01c59040471d2382646"
    sha256 cellar: :any_skip_relocation, mojave:        "205d6fa7d4c8c0bf18269eca87b38ba47e051935c4e6d29555d4f7c5b93149e7"
  end

  depends_on "ecl" => :build

  uses_from_macos "zlib"

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

    ENV["SBCL_MACOSX_VERSION_MIN"] = MacOS.version
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
