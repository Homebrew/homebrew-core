class Teku < Formula
  desc "Java Implementation of the Ethereum 2.0 Beacon Chain"
  homepage "https://docs.teku.consensys.net/"
  license "Apache-2.0"
  head "https://github.com/ConsenSys/teku.git", branch: "master"

  stable do
    url "https://github.com/ConsenSys/teku.git",
        tag:      "23.3.0",
        revision: "e895b424cba784ad987d1c2db49e1c30e0432c56"

    # Fix build with gradle 8.0. Remove with stable block on next release.
    patch do
      url "https://github.com/ConsenSys/teku/commit/e557eef6550ad91b05ee7adc52d70c7373f6912f.patch?full_index=1"
      sha256 "c5e7aca45bafd31fb3f3a3eb56a33ff269f504fb74c6d4de764fa046c68e788e"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c677013ffd68b1900da5c6ce52bc73f5284ea4e0f048a8fdf57efb52b055d7ca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c677013ffd68b1900da5c6ce52bc73f5284ea4e0f048a8fdf57efb52b055d7ca"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c677013ffd68b1900da5c6ce52bc73f5284ea4e0f048a8fdf57efb52b055d7ca"
    sha256 cellar: :any_skip_relocation, ventura:        "c677013ffd68b1900da5c6ce52bc73f5284ea4e0f048a8fdf57efb52b055d7ca"
    sha256 cellar: :any_skip_relocation, monterey:       "c677013ffd68b1900da5c6ce52bc73f5284ea4e0f048a8fdf57efb52b055d7ca"
    sha256 cellar: :any_skip_relocation, big_sur:        "c677013ffd68b1900da5c6ce52bc73f5284ea4e0f048a8fdf57efb52b055d7ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7795ad55bdee306e9c3ab4b5b3676de17f890f2a004e61685358ccd0cd47fd4a"
  end

  depends_on "gradle" => :build
  depends_on "openjdk"

  def install
    system "gradle", "installDist"

    libexec.install Dir["build/install/teku/*"]

    (bin/"teku").write_env_script libexec/"bin/teku", Language::Java.overridable_java_home_env
  end

  test do
    assert_match "teku/", shell_output("#{bin}/teku --version")

    rest_port = free_port
    fork do
      exec bin/"teku", "--rest-api-enabled", "--rest-api-port=#{rest_port}", "--p2p-enabled=false", "--ee-endpoint=http://127.0.0.1"
    end
    sleep 15

    output = shell_output("curl -sS -XGET http://127.0.0.1:#{rest_port}/eth/v1/node/syncing")
    assert_match "is_syncing", output
  end
end
