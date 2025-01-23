class Thanos < Formula
  desc "Highly available Prometheus setup with long term storage capabilities"
  homepage "https://thanos.io"
  url "https://github.com/thanos-io/thanos/archive/refs/tags/v0.37.2.tar.gz"
  sha256 "ebe569241c38bc2e055c0f5fa24172f636b8922b74f1e5dc6a184fb31b66e73c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34af92559c31c6314dab4e9d7d19b0172db419ec4d59b8e4b4310967394a0037"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7be18286498e903e6bb8c856b83ba47be12e80d74c258bcddea52ae1e8f9d974"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d64669ff71822a9ae84ebbb5d4d35f747f6ad75f824e1af5ee3d3903bcec8ce8"
    sha256 cellar: :any_skip_relocation, sonoma:        "8eade5bacdb7b65a95001341fc98ca4e5817b008f8b95ac188e634d29ef58bc9"
    sha256 cellar: :any_skip_relocation, ventura:       "19efe0e658bfe8ce280ec53b89778028c780c784b0b94053ce54683df5f9a1b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9afa740d0b1f3a4ed33ffcf6d4ecac40b744d040ab845e0174960177a07367da"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/thanos"
  end

  test do
    (testpath/"bucket_config.yaml").write <<~YAML
      type: FILESYSTEM
      config:
        directory: #{testpath}
    YAML

    output = shell_output("#{bin}/thanos tools bucket inspect --objstore.config-file bucket_config.yaml")
    assert_match "| ULID |", output
  end
end
