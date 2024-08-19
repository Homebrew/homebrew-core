class TektoncdCli < Formula
  desc "CLI for interacting with TektonCD"
  homepage "https://github.com/tektoncd/cli"
  url "https://github.com/tektoncd/cli/archive/refs/tags/v0.37.0.tar.gz"
  sha256 "60377a9b33ad292fc4a6b9dca13626acc62dbf84c44e376b7a244374d692d3a7"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c8d457696431f214fa75884fbd5613f4f5feadabdc13c730abcc5442a228c7bb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5f4de54fc339f9b95c65bceb4efb212b69d05c968dd9bbcb606f9430db215979"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "27a3ecff97ed3a3dd2ab3159f38ea2f7990d7b95a04fc2bc4ce336fc922e5ca1"
    sha256 cellar: :any_skip_relocation, sonoma:         "bf4f452691bd90a173382ccac4a2369cef0b4d8e1c9ab869f9aadd64c14c5023"
    sha256 cellar: :any_skip_relocation, ventura:        "b834c191c7bedeac0d327719943dc55c5b733283eedcfd82f5f5422cf7ee19bd"
    sha256 cellar: :any_skip_relocation, monterey:       "6f76f90509daefa57a92679565842f3d4036b0010fce0f005f8d73c336e8740f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6371e2ee93517f882691474c107b2a452b0ee8d754d38b5f0a587841bb27b83d"
  end

  depends_on "go" => :build

  def install
    system "make", "bin/tkn"
    bin.install "bin/tkn" => "tkn"

    generate_completions_from_executable(bin/"tkn", "completion", base_name: "tkn")
  end

  test do
    cmd = "#{bin}/tkn pipelinerun describe homebrew-formula"
    io = IO.popen(cmd, err: [:child, :out])
    assert_match "Error: Couldn't get kubeConfiguration namespace", io.read
  end
end
