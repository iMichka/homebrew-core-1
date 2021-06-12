class Tio < Formula
  desc "Simple TTY terminal I/O application"
  homepage "https://tio.github.io"
  url "https://github.com/tio/tio/releases/download/v1.32/tio-1.32.tar.xz"
  sha256 "a8f5ed6994cacb96780baa416b19e5a6d7d67e8c162a8ea4fd9eccd64984ae44"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cd68cb38333ea9bf99d8e0cdd28cf73ce8517b834213b2f786f29c4d58ca0dd8"
    sha256 cellar: :any_skip_relocation, big_sur:       "257626785fcbbab8298a98f912c7831b1c9565536ff6425c438424fca3163d90"
    sha256 cellar: :any_skip_relocation, catalina:      "a630b860983adbd4c2691538739850ef934aeafcfa33c5561a00e3db2b355e88"
    sha256 cellar: :any_skip_relocation, mojave:        "f33b4bc0d653c0f2111f0c30865395d2cadfe524f33ab1c84c843e54ec432ed9"
    sha256 cellar: :any_skip_relocation, high_sierra:   "1241b11c102b527fd43225a3283290fe5488889a9e0919e7b4b536ddcb4a4d83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "204f139cbc573038264c0b660f29fb128d2a785f5a9532698d7379781c430453"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-bash-completion-dir=#{bash_completion}"
    system "make", "install"
  end

  test do
    # Test that tio emits the correct error output when run with an argument that is not a tty.
    # Use `script` to run tio with its stdio attached to a PTY, otherwise it will complain about that instead.
    test_str = "Error: Not a tty device"
    on_macos do
      assert_match test_str, shell_output("script -q /dev/null #{bin}/tio /dev/null", 1).strip
    end
    on_linux do
      assert_match test_str, shell_output("script -q /dev/null -e -c \"#{bin}/tio /dev/null\"", 1).strip
    end
  end
end
