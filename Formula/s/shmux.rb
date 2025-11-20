class Shmux < Formula
  desc "Execute the same command on many hosts in parallel"
  homepage "https://github.com/shmux/shmux"
  url "https://github.com/shmux/shmux/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "c9f8863e2550e23e633cf5fc7a9c4c52d287059f424ef78aba6ecd98390fb9ab"
  license "BSD-3-Clause"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "41cc598c5c1b6b397128af5342ad323ee355c48d782af7f574d0f9f73a5caf14"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "1c6c5f0ff3534ed4ad1c56180b80e0c1963b25c803789492c130ab0620eccb64"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2b5156cf3563aa2cca9be5a0de4e8bdd23fbd78854910a8fd25e0cf83b0d0172"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b4629c31e6233a8e7d7c4caf6491c3e585f8b7eaa5964f426ceab66562cb4fb7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e32cab0e2063d5b3d43f9e796e5b00b89f7ac2bae966efe236b1e69d8ae6e8bc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "341ede51de6b3dbb5b0f6acc554a2dfc7c9543cb3800e06a992f8b40a58b3657"
    sha256 cellar: :any_skip_relocation, sonoma:         "902fe0e6668abbd51c33c4c6cd85a0933b5e94650b319ea57d9b0581440a8d95"
    sha256 cellar: :any_skip_relocation, ventura:        "252d01294232eadb06c95e9fcd0dd73438a2871dfab43210481df95ad30df586"
    sha256 cellar: :any_skip_relocation, monterey:       "2ddc25900fb3603227d9ede578fffc8c96c414b8487f6a0d710ac0e39f6a52de"
    sha256 cellar: :any_skip_relocation, big_sur:        "6f8ae1c07788268ee86531da66940e7648dce1dc63a6ed118a2bacc0899beac9"
    sha256 cellar: :any_skip_relocation, catalina:       "6781e9876911d4d44080b069dd3295c86520699ae24b3385980d51a53bc4d2f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "31b4fe74dd2467977c7653c9b58e27fed41ff1238daf825c193678986797521e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c1e347248987cfaeb250cff852feeab54fe709da0f69d9c560170f46c05feaf4"
  end

  uses_from_macos "ncurses"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"shmux", "-h"
  end
end
