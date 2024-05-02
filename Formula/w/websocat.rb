class Websocat < Formula
  desc "Command-line client for WebSockets"
  homepage "https://github.com/vi/websocat"
  url "https://github.com/vi/websocat/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "43800f8df38ede8b5bffe825e633c0db6a3c36cfe26c23e882bcfc028d3119c7"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ad69943ce0768290eef524aa9b69d2d3313199853586bc18c32fda8a04e20532"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d75ddc5d4523e2127bd679e6e6436e306f43bf6caac96641fa52d38428ddb45b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b28525e3861934de268b3599e868d134d4f5979e1ab571e6de3154516a340b8"
    sha256 cellar: :any_skip_relocation, sonoma:         "f31b9e73fd06fedc160428c42a31b139b719581994e2e3f378b6a444189dc383"
    sha256 cellar: :any_skip_relocation, ventura:        "bd3d8b8e591a95b50ea80806f62604fe53e1a9bfccbf11587e6434d7b39686b8"
    sha256 cellar: :any_skip_relocation, monterey:       "cfa0efba1c5f8ea16042cd57891bdea87faa379ae0f5cdc32108422dc9aef6d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7d5dbdeca5e44981f69b3d1b93911932d7951e374c544379452b09dc3ded2af"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", "--features", "ssl", *std_cargo_args
  end

  test do
    system "#{bin}/websocat", "-t", "literal:qwe", "assert:qwe"
  end
end
