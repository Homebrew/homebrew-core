class Sbcl < Formula
  desc "Steel Bank Common Lisp system"
  homepage "https://www.sbcl.org/"
  url "https://downloads.sourceforge.net/project/sbcl/sbcl/2.4.7/sbcl-2.4.7-source.tar.bz2"
  sha256 "68544d2503635acd015d534ccc9b2ae9f68996d429b5a9063fd22ff0925011d2"
  license all_of: [:public_domain, "MIT", "Xerox", "BSD-3-Clause"]
  head "https://git.code.sf.net/p/sbcl/sbcl.git", branch: "master"

  livecheck do
    url "https://sourceforge.net/projects/sbcl/rss?path=/sbcl"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "68752979aeb063c2183f2ee71d5804645c90804aaac3aa6ddc50e0196a3b620d"
    sha256 cellar: :any,                 arm64_ventura:  "6e5bb311ab48f05b22b24377a70e3e6f00124e5e3b8190d22d17712810c990d0"
    sha256 cellar: :any,                 arm64_monterey: "ebf3c5c9b39978d9e9a6c675dce5aadbc6b6346e7653ba7892d3f519b6a837cc"
    sha256 cellar: :any,                 sonoma:         "411b75246fe297a3c0a8fc636b6a3cb3eec3f94b430cbc81f266c990be1cf377"
    sha256 cellar: :any,                 ventura:        "759434c3e90b9496d44b579d8efca6618b38f93b55c5d7d71436405f9d777e87"
    sha256 cellar: :any,                 monterey:       "3d2027fac4271cf30b709550ce6dd313cf425f10e0af09cb2e16c838cb102e91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47243a8073ba39f7edd6dc454a46d87fcdfc9bf53c9931a7eae320332c442498"
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
