class SourceToImage < Formula
  desc "Tool for building source and injecting into docker images"
  homepage "https://github.com/openshift/source-to-image"
  url "https://github.com/openshift/source-to-image.git",
      tag:      "v1.5.1",
      revision: "c301811d969b777bfe058016bf97a8b0441b581a"
  license "Apache-2.0"
  head "https://github.com/openshift/source-to-image.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7735582f91687e77f5e48c13fa4c8a53ce5fccb4432e68799ed548c869801ef5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7778f7eed763ebd1813a981473c5dc3420e4f1e537b385ddfb04d732c248c19"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5859f81f7f4b2e3c99b9e404a4b31d8f8bb819a6cc353a12d682298541420f29"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d3f76254dcc783550de56245b53142ca82df53ee5df5708eab4614a201ac3843"
    sha256 cellar: :any_skip_relocation, sonoma:        "140175f74190d78aa15506c88c60e4b0edf3f0a610631331cf5c89be2c07d499"
    sha256 cellar: :any_skip_relocation, ventura:       "4306563c8c5eac66011ea690f7c334334f5769b9b72986483201f7c8a3eed88d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b56f0ebfe195a88d684881f6240c4c2a2ea906a9e62c9b4b8ac667831b2f11ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "274fd87a87e799afb59ec2e03b3ac12bf555f491bf0395ff1921c353d87375ad"
  end

  depends_on "go" => :build

  def install
    system "hack/build-go.sh"
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    bin.install "_output/local/bin/#{OS.kernel_name.downcase}/#{arch}/s2i"

    generate_completions_from_executable(bin/"s2i", "completion", shells: [:bash, :zsh])
  end

  test do
    system bin/"s2i", "create", "testimage", testpath
    assert_path_exists testpath/"Dockerfile", "s2i did not create the files."
  end
end
