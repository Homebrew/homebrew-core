class Thanos < Formula
  desc "Highly available Prometheus setup with long term storage capabilities"
  homepage "https://thanos.io"
  url "https://github.com/thanos-io/thanos/archive/v0.25.0.tar.gz"
  sha256 "4bdc1f8aa357a1dd74f83fe26c5c3a8f33e3b6166f81858caa0a20b5645dc733"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5fb15ff269d1e43385927ce134d1d81a124ba22381e863b6b0e69dcbc7cac324"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4413e7ed12d9e23df7bebbe180f0f4bf07d81768c2d26a31654185908e7d2417"
    sha256 cellar: :any_skip_relocation, monterey:       "1545356e11d037c52f8bf3e4ba95fb57e3e83b96dcbf5be9ca69d7dc15484b4e"
    sha256 cellar: :any_skip_relocation, big_sur:        "c33abc25e4196d98325799abefb7b2d34e2c213351ef146b404362acb60133ec"
    sha256 cellar: :any_skip_relocation, catalina:       "15af5d1a53a29eadfa0ce48969291d8a5d90966490d9d163c6b9f82feb7505dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6cfb1abaa66e78843c3629271772f55497a349322fe581495aa01c9092696bec"
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
