class Sbcl < Formula
  desc "Steel Bank Common Lisp system"
  homepage "https://www.sbcl.org/"
  url "https://downloads.sourceforge.net/project/sbcl/sbcl/2.6.3/sbcl-2.6.3-source.tar.bz2"
  sha256 "e7432fb642952dd25a5fc0c56d218f3d0aa596ce42d33efa83091bca7d69988a"
  license all_of: [:public_domain, "MIT", "Xerox", "BSD-3-Clause"]
  compatibility_version 2
  head "https://git.code.sf.net/p/sbcl/sbcl.git", branch: "master"

  livecheck do
    url "https://sourceforge.net/projects/sbcl/rss?path=/sbcl"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "827c8d74236e71fae9d70b6c12eef97a91600f1bb2b37c62d618bcc8b55a91e7"
    sha256 cellar: :any,                 arm64_sequoia: "a058ebfe56cebf0440b3841a30e0a4b6c61b9c8a098f23bc4b75ca3e9c8fa77c"
    sha256 cellar: :any,                 arm64_sonoma:  "b31e2c30dabddcff73d8fb93f32497918e9402f82e72c9c0728b9aa337c36b2f"
    sha256 cellar: :any,                 sonoma:        "169bd86053af6824eaf209569084b6e0d5b8e6cbc6621fc4ac398f6ac0774e03"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "afb34e28909281ebf2f649a1c8938b6329727672eb258456af855fd8f9f7b416"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73e15c32771621dbfafc6894b6d4e6fbfa6d46c3547138ad208bfd4b71dec3b0"
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
