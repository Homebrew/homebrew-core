class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-7.1.5.tgz"
  sha256 "f1865f0cddd1672511433845754977b8eb3327c3940c6a414b5f4a60bd5fec79"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cd49e6a514ff259a0ce37045d2d5d6d0347b9b6a7a51e393d8cf1e5194c9d20f"
    sha256 cellar: :any,                 arm64_sequoia: "f9f862ff8c9ab1430912e597a5d0890f142fad84f3df12e190786080ea9d9f0f"
    sha256 cellar: :any,                 arm64_sonoma:  "f9f862ff8c9ab1430912e597a5d0890f142fad84f3df12e190786080ea9d9f0f"
    sha256 cellar: :any,                 arm64_ventura: "f9f862ff8c9ab1430912e597a5d0890f142fad84f3df12e190786080ea9d9f0f"
    sha256 cellar: :any,                 sonoma:        "10352426952425c97d13bba7c57b5b0d5273ce0b50d725c14a113647da79706d"
    sha256 cellar: :any,                 ventura:       "10352426952425c97d13bba7c57b5b0d5273ce0b50d725c14a113647da79706d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38595e8cb52146b733a23bb6b93fcb5342adc3524a4c95dbd205fd6d793d612f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0e81794dd5b003265bde2a630547eb9870060455379d58f3bb73f8e118181da"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/vite optimize --force")
    assert_match "Forced re-optimization of dependencies", output

    output = shell_output("#{bin}/vite optimize")
    assert_match "Hash is consistent. Skipping.", output

    assert_match version.to_s, shell_output("#{bin}/vite --version")
  end
end
