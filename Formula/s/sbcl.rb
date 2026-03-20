class Sbcl < Formula
  desc "Steel Bank Common Lisp system"
  homepage "https://www.sbcl.org/"
  url "https://downloads.sourceforge.net/project/sbcl/sbcl/2.6.2/sbcl-2.6.2-source.tar.bz2"
  sha256 "afb49358fa58484ffeed0b26a1dfdd829a6fb066d4a8b25f2b0bbccfcae571d7"
  license all_of: [:public_domain, "MIT", "Xerox", "BSD-3-Clause"]
  compatibility_version 1
  head "https://git.code.sf.net/p/sbcl/sbcl.git", branch: "master"

  livecheck do
    url "https://sourceforge.net/projects/sbcl/rss?path=/sbcl"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a4caae046a84114852eb7c19baa8827f9264c0eb3d55bed855a77acd66730ce2"
    sha256 cellar: :any,                 arm64_sequoia: "c294c1415323992e40474f1ff902720b4594bbb6a77a16d8b456e7d5d9430924"
    sha256 cellar: :any,                 arm64_sonoma:  "a04d03fc1c8777e13a976266d3e4a7d5de7b4ffb61d253eb75e01ba826bb699c"
    sha256 cellar: :any,                 sonoma:        "1248193aeddb67e3db5e4d149e10643223b13da8b094d79c155feb9ac914dcba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f0369eaf77822908c8160b4948ace50163fdce41906c38e5bc1e91ea316285bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "602f29e1c3de1e95102f9eef676a1cb556fa956284a98dda54bb382b71854a31"
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
