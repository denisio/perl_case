package MenuManager;
use strict;
use warnings;

require Carp;


sub new
{
    my $class = shift;
    my (%config) = @_;

    my $self = {};
    bless $self, $class;

    $self->{menu} = [];

    return $self;
}

sub addMenu
{
    my $self = shift;
    my (@menu) = @_;

    while (@menu) {
        my $root    = shift @menu;
        my $submenu = shift @menu;
        push(@{$self->{menu}}, $root, $submenu);
    }

    return 1;
}

sub addMenuAfter
{
    my $self = shift;
    my ($anchor, @menu) = @_;

    $self->_addMenuInPosition('after', $anchor, @menu);

    return 1;
}

sub addMenuBefore
{
    my $self = shift;
    my ($anchor, @menu) = @_;

    $self->_addMenuInPosition('before', $anchor, @menu);

    return 1;
}

sub _addMenuInPosition
{
    my $self = shift;
    my ($type, $anchor, @menu) = @_;

    my @old = @{$self->{menu}};
    my @new;

    my $added = 0;
    for (my $i = 0; $i < @old; $i+=2) {
        my $title = $old[$i];
        my $menus = $old[$i+1];

        push(@new, $title, $menus) if $type eq 'after';

        if ($title eq $anchor) {
            push(@new, @menu);
            $added = 1;
        }

        push(@new, $title, $menus) if $type eq 'before';
    }
    Carp::croak("Anchor menu not found") unless $added;

    $self->{menu} = \@new;

    return 1;
}

sub addSubmenuBefore
{
    my $self = shift;
    my ($anchor, $subanchor, @new_submenu) = @_;

    $self->_addSubmenuInPosition('before', $anchor, $subanchor, @new_submenu);

    return 1;
}

sub addSubmenuAfter
{
    my $self = shift;
    my ($anchor, $subanchor, @new_submenu) = @_;

    $self->_addSubmenuInPosition('after', $anchor, $subanchor, @new_submenu);

    return 1;
}

sub _addSubmenuInPosition
{
    my $self = shift;
    my ($type, $anchor, $subanchor, @new_submenu) = @_;

    my $found_anchor = 0;
    my $found_subanchor = 0;
    for (my $i = 0; $i < @{$self->{menu}}; $i+=2) {
        my $title   = $self->{menu}->[$i];
        my $submenu = $self->{menu}->[$i+1];

        if ($title eq $anchor) {
            $found_anchor = 1;
            my @old_items = @{$submenu};
            my @new_items;
            for my $item (@old_items) {
                push(@new_items, $item) if $type eq 'after';
                if ($item->{title} eq $subanchor) {
                    $found_subanchor = 1;
                    push(@new_items, @new_submenu);
                }
                push(@new_items, $item) if $type eq 'before';
            }
            $self->{menu}->[$i+1] = \@new_items;
        }
    }
    Carp::croak("Anchor menu not found") unless $found_anchor;
    Carp::croak("Anchor submenu not found") unless $found_subanchor;

    return 1;
}


sub getMenu
{
    my $self = shift;

    my @menu;
    for (my $i = 0; $i < @{$self->{menu}}; $i+=2) {
        my $title   = $self->{menu}->[$i];
        my $submenu = $self->{menu}->[$i+1];
        push(@menu, { title => $title, url => '', submenu => $submenu });
    }

    return @menu;
}

1;
