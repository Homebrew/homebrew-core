class SourceToImage < Formula
  desc "Tool for building source and injecting into docker images"
  homepage "https://github.com/openshift/source-to-image"
  url "https://github.com/openshift/source-to-image.git",
      tag:      "v1.3.5",
      revision: "c5a053620a176349993a11dc4fad723e243c93bd"
  license "Apache-2.0"
  head "https://github.com/openshift/source-to-image.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1a3d911ca16b1ed607775d4c7e9e4fab28880dbd1547b831ae31472e7f80a189"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3626179d1848db2a88957432239c77dd930dce008df2c8a599c6997e7a2e9292"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b718b023bcabf408b4c8e4a5ce288af0a805f35c3e1f53822026167ef829d5da"
    sha256 cellar: :any_skip_relocation, ventura:        "1f2a9ea67ac49e77d104359885a180a9a9f3edb02d112cab8be964b556d20692"
    sha256 cellar: :any_skip_relocation, monterey:       "f9d5dce180203df7f9e749244cd75f619110a57b9706772a611af70b09a28ccb"
    sha256 cellar: :any_skip_relocation, big_sur:        "1fcf0d079c08dafe6f1dc8531484ad754eba54a6e1d15bc6a60d0df35027b02d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60253e3d68270a949cb05e0840c29650a48c6bda1f0e19f415c963d5dfc3c174"
  end

  depends_on "go" => :build

  def install
    system "hack/build-go.sh"
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    bin.install "_output/local/bin/#{OS.kernel_name.downcase}/#{arch}/s2i"

    generate_completions_from_executable(bin/"s2i", "completion", shells: [:bash, :zsh], base_name: "s2i")
  end

  test do
    system "#{bin}/s2i", "create", "testimage", testpath
    assert_predicate testpath/"Dockerfile", :exist?, "s2i did not create the files."
  end
end
