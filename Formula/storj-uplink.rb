class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.57.1.tar.gz"
  sha256 "5ae067e6420845c568b870a7d8795f5a94aa6435c05cbb7acf72ff1fc4803207"
  license "AGPL-3.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b33d041469e7920b6a1649d94b3faf118d958805ecdd7deb49ba6feaef386955"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e34ea120fa990de8f77a70286c682542cf690486270a204a6a32aa1fb689d1aa"
    sha256 cellar: :any_skip_relocation, monterey:       "55c51d9b82688fc04d7fc6f9ce61ca962606f3db2b4db49c4c74493100b6f409"
    sha256 cellar: :any_skip_relocation, big_sur:        "de33e8357c933619ad9b10cea624498b25499671da95248bf18ac94c59de41c2"
    sha256 cellar: :any_skip_relocation, catalina:       "8fd0a6ed8793848843f08a75dd1e4940c7b776c10167708a58d08e099552ef6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6b730d8dfc3a081026993f78ea06d073683e8a40771dd2aec3a50af7dd9e014"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-o", bin/"uplink", "./cmd/uplink"
  end

  test do
    (testpath/"config.ini").write <<~EOS
      [metrics]
      addr=
    EOS
    ENV["UPLINK_CONFIG_DIR"] = testpath.to_s
    ENV["UPLINK_INTERACTIVE"] = "false"
    assert_match "No accesses configured", shell_output("#{bin}/uplink ls 2>&1", 1)
  end
end
