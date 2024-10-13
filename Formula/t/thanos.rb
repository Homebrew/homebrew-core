class Thanos < Formula
  desc "Highly available Prometheus setup with long term storage capabilities"
  homepage "https://thanos.io"
  url "https://github.com/thanos-io/thanos/archive/refs/tags/v0.36.1.tar.gz"
  sha256 "0e0d8cec6137a2295f7b740762bc4ef6514e4602d69a7b08afd18363fba63280"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "4c0c876b03d412a85cffeba3272453e974d7fac9ee0176196fd7264de7f28f5a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3c61253125cd3af16a7e021fa6eaf198d74f11a91e2de761d39c55e609553f88"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "601c1e0ed4d5afb03a8ddae86a6c930a893c0ce874d587a68ed77e062b265924"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a275f7ee72e326d5bb052c39159a6a9139a629bb0b5cf7831728d5ee263de20"
    sha256 cellar: :any_skip_relocation, sonoma:         "a9c9d850ac2dce8d8e513f67df9324ea1a47adbaf402f4449c7e76410586bc73"
    sha256 cellar: :any_skip_relocation, ventura:        "8ff7595e4e26e0c9c80252254ce5989a856ce644e0666f5ea279687aeff85bd8"
    sha256 cellar: :any_skip_relocation, monterey:       "4150c2bcd2c75ca64a540506910d96e83ccaf0e3c64a351393722a0b43ffc8a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0bdf5c566ca91784c389e0969009c7e0a5fef8f9180aeccf74d4d12853270087"
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
