class Thanos < Formula
  desc "Highly available Prometheus setup with long term storage capabilities"
  homepage "https://thanos.io"
  url "https://github.com/thanos-io/thanos/archive/refs/tags/v0.33.0.tar.gz"
  sha256 "fa848c613355c2c5a50ce231bd5ed9131b8948d362c63a46dbec6b7dfbf2e5db"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2f23a8ad183cf466d0a910cf4d3dee439c921f9207e0e318590a65ae2fedc442"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "286e9ac60d00b528177a3dd99e81279cff0caac4773099d9835ad6538a9f91ea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f39ca911da654e76073e4fc58a03390ef57aba98732617e76762a8b05c022ff7"
    sha256 cellar: :any_skip_relocation, sonoma:         "64aac736aa0b0f3798c67cdca41829f8eea3cae3bf32adceeb1a5363ce3693b1"
    sha256 cellar: :any_skip_relocation, ventura:        "26bee41aabb6a482f6ecf01f91bbdf19e719b8b516a96ef22377165bbc21eaa9"
    sha256 cellar: :any_skip_relocation, monterey:       "0df90f767680aa692d95c45bb901d761af83d60c711e1a6002664a9a90527e00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71f7a8f3d84d7b0e95869048313b0e4abbcbf7966140394028d25c4574069788"
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
