class Wazero < Formula
  desc "Zero dependency WebAssembly runtime"
  homepage "https://wazero.io"
  url "https://github.com/tetratelabs/wazero/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "10c79ae33c927f6e9003b054a7768b7bf20f1470b9984a62969428448cba3abf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1d957b85035512488340e3d3f71dbd35b7f89044778815d504cce1d0b7f8891a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a269ea061ce6d047a78fa6a59fda006b75f8d4aaa79c10d640fd8facd7b31aca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "756efe6b1bfdf37801a2ed2057e78dbb634e19cfa7b666ebfecc1d4b19531928"
    sha256 cellar: :any_skip_relocation, sonoma:         "e00e514342ec508bce1ade36cb8aa24ceff500f247f1aa46d47c637a56fd8e06"
    sha256 cellar: :any_skip_relocation, ventura:        "24841a4a0d4f6b10ef1e5e57edac75acc8cf43d1f74914fcf8e9468d02baf2a1"
    sha256 cellar: :any_skip_relocation, monterey:       "eefc8f2836feb5aa28ec5faf5b02ed325205c819e79c7de32d072d8cd1fd9041"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff173fe459488cef0e99b47ed6f21e386334b4c8b355560afbbc3f57272b336a"
  end

  depends_on "go" => :build
  depends_on "wabt" => :test

  def install
    ldflags = %W[
      -s -w
      -X github.com/tetratelabs/wazero/internal/version.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/wazero"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/wazero version").chomp

    (testpath/"mount.wat").write <<~EOS
      ;; print the preopen directory path (guest side of the mount).
      (module
        (import "wasi_snapshot_preview1" "fd_prestat_get"
          (func $wasi.fd_prestat_get (param i32 i32) (result i32)))

        (import "wasi_snapshot_preview1" "fd_prestat_dir_name"
          (func $wasi.fd_prestat_dir_name (param i32 i32 i32) (result i32)))

        (import "wasi_snapshot_preview1" "fd_write"
          (func $wasi.fd_write (param i32 i32 i32 i32) (result i32)))

        (memory (export "memory") 1 1)

        (func $main (export "_start")
          ;; First, we need to know the size of the prestat dir name.
          (call $wasi.fd_prestat_get
            (i32.const 3) ;; preopen FD
            (i32.const 0)) ;; where to write prestat
          (drop) ;; ignore the errno returned

          ;; Next, write the dir name to offset 8 (past the prestat).
          (call $wasi.fd_prestat_dir_name
            (i32.const 3) ;; preopen FD
            (i32.const 8) ;; where to write dir_name
            (i32.load (i32.const 4))) ;; length is the last part of the prestat
          (drop) ;; ignore the errno returned

          ;; Now, convert the prestat to an iovec [offset, len] writing offset=8.
          (i32.store (i32.const 0) (i32.const 8))

          ;; Finally, copy the dirname to stdout via its iovec [offset, len].
          (call $wasi.fd_write
            (i32.const 1) ;; stdout
            (i32.const 0) ;; where's the iovec
            (i32.const 1) ;; only one iovec
            (i32.const 0)) ;; overwrite the iovec with the ignored result.
          (drop) ;; ignore the errno returned
        )
      )
    EOS

    system "wat2wasm", testpath/"mount.wat", "-o", testpath/"mount.wasm"

    assert_equal "/homebrew",
      shell_output("#{bin}/wazero run -mount=/tmp:/homebrew #{testpath/"mount.wasm"}")
  end
end
