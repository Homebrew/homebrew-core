class Thanos < Formula
  desc "Highly available Prometheus setup with long term storage capabilities"
  homepage "https://thanos.io"
  url "https://github.com/thanos-io/thanos/archive/v0.25.0.tar.gz"
  sha256 "4bdc1f8aa357a1dd74f83fe26c5c3a8f33e3b6166f81858caa0a20b5645dc733"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13d17c683b7cacdaeb7187567d82d571b2b40f68d9ce4ea602adcdd847dfe9be"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8688b8a3004e7b8afe96c6815f02bf2420f3e9accca867df60a81770752a5415"
    sha256 cellar: :any_skip_relocation, monterey:       "f3d711273db576318a63e9b545a0368364b68c70814651e8a9b6e88e77618b8e"
    sha256 cellar: :any_skip_relocation, big_sur:        "b0d22988fa170bea9bf413efe94ef3c1c2cfc8d3e198c568045f155c84d068b9"
    sha256 cellar: :any_skip_relocation, catalina:       "d2085ebe3ebdf93c54cde02189b1f73d87382b25c55b558da92981367805cd76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3efc0915f8fa3e8837f2b1148a1d5110ad16b4018dac1339d92d27573cc74071"
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
