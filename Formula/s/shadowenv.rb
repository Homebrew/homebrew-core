class Shadowenv < Formula
  desc "Reversible directory-local environment variable manipulations"
  homepage "https://shopify.github.io/shadowenv/"
  url "https://github.com/Shopify/shadowenv/archive/refs/tags/2.1.2.tar.gz"
  sha256 "545995663f754d742749fbfb0d949be0f03fc9992a4518f0f06b45593940faf5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "ef47a7fc35e2237552519f2c962586288fa8e2f797a028a41ed0ee079ef29781"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1b488bee260253a43d92f439d4e303c8940451622a9f2d3c3c3b13eb37d16209"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c0783ccae890c38c58f22ebd20090a58c4918c5e22c5e7d52cb281a7e6cbed0d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af967d51f98c69a2b402d8da33b363675168298752ad5dff824daffc811c55b9"
    sha256 cellar: :any_skip_relocation, sonoma:         "f2c1809129f77ed3dcd097e4aaa3f2587f0bb2f9a8e0dfd9d89ebef85aedf3ad"
    sha256 cellar: :any_skip_relocation, ventura:        "0219bcc301dff154c67496d88ee2b8cf8cf0a57e320bb96b3ac54ab3df07e5ca"
    sha256 cellar: :any_skip_relocation, monterey:       "82ddf47962cd1131319642d172ef613ea406472e98a32a54e96bce0c5d7c569f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0788e0776ecb8146c9c4e89d14861cd2dc7e5e2ec7701f6c06b89d8bf358b80d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "#{buildpath}/man/man1/shadowenv.1"
    man5.install "#{buildpath}/man/man5/shadowlisp.5"
  end

  test do
    expected_output = <<~EOM
      EXAMPLE:
      EXAMPLE2:b
      EXAMPLE3:b
      EXAMPLE_PATH:a:b:d
      ---
      EXAMPLE:a
      EXAMPLE2:
      EXAMPLE3:a
      EXAMPLE_PATH:c:d
    EOM
    environment = "export EXAMPLE2=b EXAMPLE3=b EXAMPLE_PATH=a:b:d;"
    hash = "1256a7c3de15e864"
    data = {
      "scalars" => [
        { "name" => "EXAMPLE2", "original" => nil, "current" => "b" },
        { "name" => "EXAMPLE", "original" => "a", "current" => nil },
        { "name" => "EXAMPLE3", "original" => "a", "current" => "b" },
      ],
      "lists"   => [
        { "name" => "EXAMPLE_PATH", "additions" => ["b", "a"], "deletions" => ["c"] },
      ],
    }
    # Read ...'\"'\"'... on the next line as a ruby `...' + "'" + '...` but for bash
    shadowenv_command = "#{bin}/shadowenv hook '\"'\"'#{hash}:#{data.to_json}'\"'\"' 2> /dev/null"
    print_vars =
      "echo EXAMPLE:$EXAMPLE; echo EXAMPLE2:$EXAMPLE2; echo EXAMPLE3:$EXAMPLE3; echo EXAMPLE_PATH:$EXAMPLE_PATH;"

    assert_equal expected_output,
      shell_output("bash -c '#{environment} #{print_vars} echo ---; eval \"$(#{shadowenv_command})\"; #{print_vars}'")
  end
end
