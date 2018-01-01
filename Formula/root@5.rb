class RootAT5 < Formula
  desc "Object oriented framework for large scale data analysis"
  homepage "https://root.cern.ch"
  url "https://root.cern.ch/download/root_v5.34.36.source.tar.gz"
  version "5.34.36"
  sha256 "fc868e5f4905544c3f392cc9e895ef5571a08e48682e7fe173bd44c0ba0c7dcd"
  revision 3

  bottle do
    sha256 "e4a87f41beae74b8ddae2f46f0e757de7cedbcda83d53092a5edf9c2fa5d6e58" => :sierra
    sha256 "9acd7ee5e7d1fa8a65889ab89ff397d5be6a777179066d961ce49815f7ef953d" => :el_capitan
    sha256 "f570484d7f040594bf33b566c53c89073d6df39ebac8f84c31d4f7b5eb9a75df" => :yosemite
  end

  keg_only :versioned_formula

  if MacOS.version == :sierra
    # Same as https://root.cern.ch/gitweb/?p=root.git;a=patch;h=b86b8376e0c49d45cd909619bbf058d45398b9a9
    # but with the change to LICENSE.txt removed to prevent it from failing
    # Only needed so patch below can apply successfully
    patch do
      url "https://gist.githubusercontent.com/ilovezfs/df76b33d0e4da8243508d44e8ce9eda9/raw/fd149d6dafcae4aae5dbbc86e7ea2bef7430274f/gistfile1.txt"
      sha256 "4214bc69f46c97f4e2d545c3942d8ec158105e4059f25f7f2323671377603e3f"
    end

    # Patch for macOS Sierra; remove for > 5.34.36
    # Already fixed in the v5-34-00-patches branch
    patch do
      url "https://root.cern.ch/gitweb/?p=root.git;a=patch;h=c06fdeae0b3b4d627aacef2bda9df0acd079626b"
      sha256 "90b8cbf99d6c1d6f04e0ad1ee0c1afeefa798b67151be63008f0573b5ed8d0f3"
    end
  end

  depends_on "fftw"
  depends_on "gsl"
  depends_on "openssl"
  depends_on "xrootd"
  depends_on :x11 => :optional
  depends_on "python" if MacOS.version <= :snow_leopard

  skip_clean "bin"

  def install
    args = %W[
      --all
      --prefix=#{prefix}
      --elispdir=#{share}/emacs/site-lisp/#{name}
      --etcdir=#{prefix}/etc/root
      --mandir=#{man}
      --disable-ruby
      --enable-builtin-freetype
      --enable-builtin-glew
      --enable-mathmore
    ]

    args << "--disable-cocoa" << "--enable-x11" if build.with? "x11"

    system "./configure", *args
    system "make"
    system "make", "install"
    chmod 0755, Dir[bin/"*.*sh"]
  end

  def caveats; <<~EOS
    Because ROOT depends on several installation-dependent
    environment variables to function properly, you should
    add the following commands to your shell initialization
    script (.bashrc/.profile/etc.), or call them directly
    before using ROOT.

    For bash users:
      . #{opt_bin}/thisroot.sh
    For zsh users:
      pushd #{opt_prefix} >/dev/null; . bin/thisroot.sh; popd >/dev/null
    For csh/tcsh users:
      source #{opt_bin}/thisroot.csh
    EOS
  end

  test do
    (testpath/"test.C").write <<~EOS
      #include <iostream>
      void test() {
        std::cout << "Hello, world!" << std::endl;
      }
    EOS
    (testpath/"test.bash").write <<~EOS
      . #{bin}/thisroot.sh
      root -l -b -n -q test.C
    EOS
    assert_equal "\nProcessing test.C...\nHello, world!\n",
      `/bin/bash test.bash`
  end
end
