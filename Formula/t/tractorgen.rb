class Tractorgen < Formula
  desc "Generates ASCII tractor art"
  homepage "https://vergenet.net/~conrad/software/tractorgen/"
  url "https://vergenet.net/~conrad/software/tractorgen/dl/tractorgen-0.31.7.tar.gz"
  sha256 "469917e1462c8c3585a328d035ac9f00515725301a682ada1edb3d72a5995a8f"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?tractorgen[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "81c1cbe1001cfa689511d5c002fdf3a4f619fa0973a3c86b376e34ef5bedfe4c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2bedfd7170837438de7a29894660b3ae2e9c885167792ef3521a19e419c9e91"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "139afef5c6ba8b491a2365fa5df36592c3e5ff42f68891af662713f086779237"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8d231cca23211331c6edbdd485855ff0ca9cbf8f302cd3717b501b5057f710c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "2276a12b428001802e9b1c2fa9921260adf74219eb55e1595c249f3c2e1c288b"
    sha256 cellar: :any_skip_relocation, ventura:       "ba42862bdd4dd45376fa17c8ba2121a30d4161f700780a53bfd9f6fc8077c40c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "69199dd0c7cdbb707559f20a2cd85e9532ccceac3640496bc7807e38cfc099f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f332d2d3f6b3f7f4ce26f3bce0b598b44fec0e173fef2bec1bad5843b6b9744f"
  end

  # Backport fix for error: call to undeclared function 'atoi'
  patch do
    url "https://github.com/kfish/tractorgen/commit/294162055ba4ab3a5a80a5ae1cfbdcbe92584239.patch?full_index=1"
    sha256 "1848b797ec759c1dfe97fe42cb20f5316b08b7b710fd1dba19b7443879af8dfb"
  end

  def install
    # Workaround for Xcode 14.3. Alternatively could autoreconf but that requires additional dependencies.
    ENV.append_to_cflags "-Wno-implicit-int" if DevelopmentTools.clang_build_version >= 1403

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    expected = <<~'EOS'.gsub(/^/, "     ") # needs to be indented five spaces
          r-
         _|
        / |_\_    \\
       |    |o|----\\
       |_______\_--_\\
      (O)_O_O_(O)    \\
    EOS
    assert_equal expected, shell_output("#{bin}/tractorgen 4")
  end
end
