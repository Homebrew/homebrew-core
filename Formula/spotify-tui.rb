class SpotifyTui < Formula
  desc "Terminal-based client for Spotify"
  homepage "https://github.com/Rigellute/spotify-tui"
  license "MIT"
  head "https://github.com/Rigellute/spotify-tui.git", branch: "master"

  stable do
    url "https://github.com/Rigellute/spotify-tui/archive/v0.25.0.tar.gz"
    sha256 "9d6fa998e625ceff958a5355b4379ab164ba76575143a7b6d5d8aeb6c36d70a7"

    # Update dirs in order to apply socket2 PR. Remove in the next release.
    patch do
      url "https://github.com/Rigellute/spotify-tui/commit/3881defc1ed0bcf79df1aef4836b857f64be657c.patch?full_index=1"
      sha256 "7405e773a49c9b6635fa6a559506e341c4ce38202388e7d7c6700964469d7f37"
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2185bb29e510fc37ff8b3b4ba7c773ac123eaecae4b445d148a1e8386f1ac4da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b954b9ac5a2d06df7d91437f8cb6482a70e2e1d8272cf7a1bb2228c209249d3a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c288dda23d5db93085af63cda53114e2805d4d158460383f75edd4a9239e57ec"
    sha256 cellar: :any_skip_relocation, ventura:        "4a7dc0f39df30abe4faa21927fb59c5d9d0fd9fe64e312ef9af2ff495a5dc307"
    sha256 cellar: :any_skip_relocation, monterey:       "ea4f9319ebe04feeb8f65d9a6b16e6d527285c2da7ca0e29e9352c4253b735f4"
    sha256 cellar: :any_skip_relocation, big_sur:        "d0751434bfb6cc8d21772aa9d00ff517dc6cb3e613b31ee552c0e15a91ae83e5"
    sha256 cellar: :any_skip_relocation, catalina:       "f0cb2c9f0af0c31d1e49e5155a2028379fd00e3880407adbf68fa2fe390d7688"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5214a242010de3e25360daf3d1322f353b626e22ca784302032a12bf92a8616c"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libxcb"
    depends_on "openssl@1.1"
  end

  # Fix build with Rust 1.64+ by updating socket2 using open dependabot PR.
  # PR ref: https://github.com/Rigellute/spotify-tui/pull/990
  patch do
    url "https://github.com/Rigellute/spotify-tui/commit/14df9419cf72da13f3b55654686a95647ea9dfea.patch?full_index=1"
    sha256 "44f95b14320eb3274131f6676c1fb7bc4096735a16592a01fc1164dbe3a064e5"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = testpath/"output"
    fork do
      $stdout.reopen(output)
      $stderr.reopen(output)
      exec "#{bin}/spt -c #{testpath}/client.yml"
    end
    sleep 10
    assert_match "Enter your Client ID", output.read
  end
end
