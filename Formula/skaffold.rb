class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://github.com/GoogleCloudPlatform/skaffold"
  url "https://github.com/GoogleCloudPlatform/skaffold.git",
      :tag => "v0.4.0",
      :revision => "8a99affded87a0f81e3ee90bd9f24f01aec5038d"

  bottle do
    cellar :any_skip_relocation
    sha256 "b8d0abcecad2587bf275e57cfdfefd4994f705cff071922ed5603b408cfe87bc" => :high_sierra
    sha256 "8dbee6f3e56c196f41c40d3dc00c3c6fe000ea97a027d0d65ddd076949ccd579" => :sierra
    sha256 "f7713b36fef03ccacdd692ef57d36b4f28ab2a3d9c66f521aec820b70d8ae8e8" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/GoogleCloudPlatform/skaffold"
    dir.install buildpath.children - [buildpath/".brew_home"]
    cd dir do
      system "make"
      bin.install "out/skaffold"
      prefix.install_metafiles
    end
  end

  test do
    output = shell_output("#{bin}/skaffold version --output {{.GitTreeState}}")
    assert_match "clean", output
  end
end
