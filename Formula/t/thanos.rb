class Thanos < Formula
  desc "Highly available Prometheus setup with long term storage capabilities"
  homepage "https://thanos.io"
  url "https://github.com/thanos-io/thanos/archive/refs/tags/v0.34.0.tar.gz"
  sha256 "6ad9755ba3f9c51bb96dbe2c3a10494b6d6d1db79ea250436aa51e783fde4abb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9b69c1cddad5adc3bc7a48c6165f54d9a95a5498bb7aee2982111b4cf4ab720c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "29810ae735b212eb18f9178ff62e8f5b687373a36110652d7859e3483773456a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8cbb84936e418921bd5c1ec58d82a20d307cdee115f64af55e5673a9c7e110ab"
    sha256 cellar: :any_skip_relocation, sonoma:         "441561952db83696223d30e422e4560bd498927668afd80e477b4042306b87fb"
    sha256 cellar: :any_skip_relocation, ventura:        "99d79d51a73a5800619e856f48c09d7ae6fe7493a5e02659eb5f22598fdb505e"
    sha256 cellar: :any_skip_relocation, monterey:       "b806825a82849ba081418d2e6c3883d22ffcb7ea92705768c5642e25bd439360"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa62730f84eb041bb0814efe9aab9fe0a74e7ddab6c3b35756fc6f48046c0fff"
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
