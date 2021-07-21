class Thanos < Formula
  desc "Highly available Prometheus setup with long term storage capabilities"
  homepage "https://thanos.io"
  url "https://github.com/thanos-io/thanos/archive/v0.22.0.tar.gz"
  sha256 "dd3b86719efee738402c6b9ce0686055447ae9ab5ce9a64c3a357c914c651073"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "dc0d0653d316182d3337117ed6d139ca0610c6ae3cfb984ccb9bfff53b86bb32"
    sha256 cellar: :any_skip_relocation, big_sur:       "56961cbfcb49226f7ecee46c1225a013a34dcd76167952a20e90b853bebc2e74"
    sha256 cellar: :any_skip_relocation, catalina:      "69166b1da6ee07d6257fb3334f992ef168e83012dea18a011ab786eccf670277"
    sha256 cellar: :any_skip_relocation, mojave:        "9fa302ae777114c48f92e3347b09e26157098465b860a26496763e0d9218272f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42414e4b433bc5f3774b6fed59c44c47c02cf1d1fd14027f760f037dc7045e67"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/thanos"
  end

  test do
    (testpath/"bucket_config.yaml").write <<~EOS
      type: FILESYSTEM
      config:
        directory: #{testpath}
    EOS

    output = shell_output("#{bin}/thanos tools bucket inspect --objstore.config-file bucket_config.yaml")
    assert_match "| ULID |", output
  end
end
