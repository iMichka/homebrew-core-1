class Wxmaxima < Formula
  desc "Cross platform GUI for Maxima"
  homepage "https://wxmaxima-developers.github.io/wxmaxima/"
  url "https://github.com/wxMaxima-developers/wxmaxima/archive/Version-19.12.1.tar.gz"
  sha256 "ce37361141821ce58cd3be5c316c40a8f19b741eb20c936d86152bfae1f101f5"
  head "https://github.com/wxMaxima-developers/wxmaxima.git"

  bottle do
    cellar :any
    sha256 "713e5a4c38c8df73e4494356c9a7fde6f1bedfcaad3029ea729af3387ff43c2e" => :catalina
    sha256 "9a4c9089f8a13451b76a9e310ddc486e9fe75bbb699b79b7ec11ddc30979fbed" => :mojave
    sha256 "6bc73da6650a0806a29b93136957a0d1814aaada9a9d1f2807a9fc81520f9134" => :high_sierra
    sha256 "07b16b76d7b24737873ba2f16ebf44e03cf6eebce8bb14d1de567dee43e4bd13" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "wxmac"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    prefix.install "wxMaxima.app" if OS.mac?

    bash_completion.install "data/wxmaxima"
  end

  def caveats; <<~EOS
    When you start wxMaxima the first time, set the path to Maxima
    (e.g. #{HOMEBREW_PREFIX}/bin/maxima) in the Preferences.

    Enable gnuplot functionality by setting the following variables
    in ~/.maxima/maxima-init.mac:
      gnuplot_command:"#{HOMEBREW_PREFIX}/bin/gnuplot"$
      draw_command:"#{HOMEBREW_PREFIX}/bin/gnuplot"$
  EOS
  end

  test do
    # Test is disbaled on Linux as circle has no X (Error: Unable to initialize GTK+, is DISPLAY set properly)
    assert_match "algebra", shell_output("#{bin}/wxmaxima --help 2>&1", 255) if OS.mac?
  end
end
