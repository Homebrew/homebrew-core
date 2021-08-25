class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https://syncthing.net/"
  url "https://github.com/syncthing/syncthing/archive/v1.18.1.tar.gz"
  sha256 "808a373c3fed3eae7631bbf1edbced14abb050240b1a0ff6caff0980af7f0f01"
  license "MPL-2.0"
  head "https://github.com/syncthing/syncthing.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "93408ed3d13d1a9b7d4388b7857e43e43c734c3f36d20aabf7f2fb64292116b7"
    sha256 cellar: :any_skip_relocation, big_sur:       "97cfcafe079181f9a20e0673770d5561cd1dda8d0ee8926069000138c0f8738d"
    sha256 cellar: :any_skip_relocation, catalina:      "90fc7936bc0cff2f2f72e92ebcc20c1d26cf59fbcc619cecefb7319ed20799c1"
    sha256 cellar: :any_skip_relocation, mojave:        "134db0b81f91e980ef4308458f36bb752cf26decd5089f1a27194408ab5195d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "864f0e8513996dd076feddddf35068ea78165951aba089acc5b87dea8abc04b2"
  end

  depends_on "go" => :build

  # Support go 1.17, remove after next release
  # Patch is equivalent to https://github.com/syncthing/syncthing/pull/7895,
  # but does not apply cleanly
  patch :DATA

  def install
    build_version = build.head? ? "v0.0.0-#{version}" : "v#{version}"
    system "go", "run", "build.go", "--version", build_version, "--no-upgrade", "tar"
    bin.install "syncthing"

    man1.install Dir["man/*.1"]
    man5.install Dir["man/*.5"]
    man7.install Dir["man/*.7"]
  end

  service do
    run [opt_bin/"syncthing", "-no-browser", "-no-restart"]
    keep_alive true
    log_path var/"log/syncthing.log"
    error_log_path var/"log/syncthing.log"
  end

  test do
    build_version = build.head? ? "v0.0.0-#{version}" : "v#{version}"
    assert_match "syncthing #{build_version} ", shell_output("#{bin}/syncthing --version")
    system bin/"syncthing", "-generate", "./"
  end
end

__END__
diff --git a/go.mod b/go.mod
index 7f816508a..64fb7aede 100644
--- a/go.mod
+++ b/go.mod
@@ -48,7 +48,7 @@ require (
 	github.com/vitrun/qart v0.0.0-20160531060029-bf64b92db6b0
 	golang.org/x/crypto v0.0.0-20210421170649-83a5a9bb288b
 	golang.org/x/net v0.0.0-20210428140749-89ef3d95e781
-	golang.org/x/sys v0.0.0-20210426230700-d19ff857e887
+	golang.org/x/sys v0.0.0-20210819135213-f52c844e1c1c
 	golang.org/x/text v0.3.6
 	golang.org/x/time v0.0.0-20210220033141-f8bda1e9f3ba
 	golang.org/x/tools v0.1.0
diff --git a/go.sum b/go.sum
index 11f4fd973..18c04e919 100644
--- a/go.sum
+++ b/go.sum
@@ -592,6 +592,8 @@ golang.org/x/sys v0.0.0-20210309074719-68d13333faf2/go.mod h1:h1NjWce9XRLGQEsW7w
 golang.org/x/sys v0.0.0-20210423082822-04245dca01da/go.mod h1:h1NjWce9XRLGQEsW7wpKNCjG9DtNlClVuFLEZdDNbEs=
 golang.org/x/sys v0.0.0-20210426230700-d19ff857e887 h1:dXfMednGJh/SUUFjTLsWJz3P+TQt9qnR11GgeI3vWKs=
 golang.org/x/sys v0.0.0-20210426230700-d19ff857e887/go.mod h1:h1NjWce9XRLGQEsW7wpKNCjG9DtNlClVuFLEZdDNbEs=
+golang.org/x/sys v0.0.0-20210819135213-f52c844e1c1c h1:Lyn7+CqXIiC+LOR9aHD6jDK+hPcmAuCfuXztd1v4w1Q=
+golang.org/x/sys v0.0.0-20210819135213-f52c844e1c1c/go.mod h1:oPkhp1MJrh7nUepCBck5+mAzfO9JrbApNNgaTdGDITg=
 golang.org/x/term v0.0.0-20201126162022-7de9c90e9dd1/go.mod h1:bj7SfCRtBDWHUb9snDiAeCFNEtKQo2Wmx5Cou7ajbmo=
 golang.org/x/text v0.0.0-20170915032832-14c0d48ead0c/go.mod h1:NqM8EUOU14njkJ3fqMW+pc6Ldnwhi/IjpwHt7yyuwOQ=
 golang.org/x/text v0.3.0/go.mod h1:NqM8EUOU14njkJ3fqMW+pc6Ldnwhi/IjpwHt7yyuwOQ=
